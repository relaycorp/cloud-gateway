#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

set -x

# Constants and functions

replace_env_var() {
  local env_var_name="$1"
  local file_path="$2"

  local env_var_value="${!env_var_name?${env_var_name} is undefined}"

  sed "s/\${${env_var_name}}/${env_var_value}/g" -i "${file_path}"
}

REPLACEABLE_ENV_VARS=(
  'GW_MANAGED_CERT_NAME'
  'GW_POWEB_DOMAIN'
  'GW_POHTTP_DOMAIN'
  'GW_COGRPC_DOMAIN'
)

# Main

CRDS_DIR="$(dirname "${BASH_SOURCE[0]}")/crds"
ls -lA "${CRDS_DIR}"
for manifest in "${CRDS_DIR}"/*.yml; do
  echo "manifest=${manifest}"
  for env_var in "${REPLACEABLE_ENV_VARS[@]}"; do
    replace_env_var "${env_var}" "${manifest}"
  done
done
