#!/bin/bash

# Initialise Vault and encrypt the keys without leaving a plaintext version behind

set -o nounset
set -o errexit
set -o pipefail
# shellcheck disable=SC1090
. "$(dirname "${BASH_SOURCE[0]}")/../scripts/_helmfile_hook_error.sh"

# Constants

RECOVERY_SHARES=3
RECOVERY_THRESHOLD=2

# Functions

vault() {
  kubectl exec "${POD_NAME}" -- vault "${@}"
}

is_vault_initialised() {
  vault operator init -status
}

initialise_vault() {
  vault operator init \
    -format=json \
    -recovery-shares="${RECOVERY_SHARES}" \
    -recovery-threshold="${RECOVERY_THRESHOLD}" \
    -recovery-pgp-keys="keybase:${KEYBASE_USERNAME},keybase:${KEYBASE_USERNAME},keybase:${KEYBASE_USERNAME}"
}

wait_for_vault_unseal() {
  timeout 15 kubectl exec "${POD_NAME}" -- sh -c "while ! vault status >>dev/null; do sleep 1; done"
}

enable_kv_engine() {
  local kv_prefix="$1"
  local vault_token="$2"

  kubectl exec "${POD_NAME}" -- \
    sh -c "VAULT_TOKEN=\"${vault_token}\" vault secrets enable -path=\"${kv_prefix}\" kv-v2"
}

keybase_encrypt() {
  local keybase_username="$1"

  apk add --update --quiet gnupg

  local public_key_url="https://keybase.io/${keybase_username}/pgp_keys.asc"
  gpg --recipient-file <(curl --silent "${public_key_url}") --encrypt --armor
}

# Main

KEYBASE_USERNAME="$1"
VAULT_KV_PREFIX="$2"
VAULT_GCS_BUCKET="$3"
HELM_RELEASE_NAME="$4"

POD_NAME="$(
  kubectl get pod \
    -l "app.kubernetes.io/name=vault,app.kubernetes.io/instance=${HELM_RELEASE_NAME}" \
    --no-headers \
    --output=jsonpath='{.items[0].metadata.name}'
)"

if is_vault_initialised; then
  echo "Vault is already initialised"
else
  echo -n "Vault is not initialised; will initialise it... "
  # Can't redirect to file directly due to permission issues; has to be done via `cat`
  initialise_vault | cat >vault-init.json
  trap "shred -u vault-init.json" INT TERM EXIT
  wait_for_vault_unseal
  echo "Done."

  apt-get install -y jq

  sleep 3s # Wait a bit longer for the KV endpoint to become operational
  root_token="$(jq --raw-output .root_token vault-init.json)"
  enable_kv_engine "${VAULT_KV_PREFIX}" "${root_token}"

  keybase_encrypt "${KEYBASE_USERNAME}" <vault-init.json >vault-init.asc

  gsutil cp vault-init.asc "gs://${VAULT_GCS_BUCKET}/relaycorp/vault-init.asc"
fi
