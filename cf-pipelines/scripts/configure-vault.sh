#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

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
  kubectl exec "${POD_NAME}" -- sh -c "VAULT_TOKEN="${vault_token}" vault secrets enable -path="${kv_prefix}" kv-v2"
}

# Main

KEYBASE_USERNAME="$1"
VAULT_KV_PREFIX="$2"

POD_NAME="$(
  kubectl get pod \
    -l app.kubernetes.io/name=vault \
    --no-headers \
    --output=jsonpath='{.items[0].metadata.name}'
)"

if is_vault_initialised; then
  echo "Vault is already initialised"
else
  echo "Vault is not initialised; will initialise it..."

  # Can't redirect to file directly due to permission issues; has to be done via `cat`
  initialise_vault | cat >vault-init.json

  wait_for_vault_unseal
  sleep 15s

  root_token="$(jq --raw-output .root_token vault-init.json)"
  enable_kv_engine "${VAULT_KV_PREFIX}" "${root_token}"
fi
