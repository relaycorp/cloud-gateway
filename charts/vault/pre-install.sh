#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

# Constants and functions

SOURCE_RESOURCES_FILE="$(dirname "${BASH_SOURCE[0]}")/resources.yml"
DESTINATION_RESOURCES_FILE='/tmp/vault.yml'

REPLACEABLE_ENV_VARS=(
  'CLOUDSDK_CORE_PROJECT'
  'VAULT_KMS_KEY_RING'
  'VAULT_KMS_AUTOUNSEAL_KEY'
  'VAULT_GCS_BUCKET'
  'VAULT_SA_KEY'
)

replace_env_var() {
  local env_var_name="$1"
  local file_path="$2"

  local env_var_value="${!env_var_name}"

  sed "s/\${${env_var_name}}/${env_var_value}/g" -i "${file_path}"
}

# Main

cp "${SOURCE_RESOURCES_FILE}" "${DESTINATION_RESOURCES_FILE}"
trap "shred -u '${DESTINATION_RESOURCES_FILE}'" INT TERM EXIT

echo -n "Resolving environment variables... "
for env_var in "${REPLACEABLE_ENV_VARS[@]}"; do
  replace_env_var "${env_var}" "${DESTINATION_RESOURCES_FILE}"
done
echo "Done"

echo "Applying resources..."
kubectl apply --filename="${DESTINATION_RESOURCES_FILE}" --wait
