#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

# Constants and functions

retrieve_secret() {
  local secret_version="$1"

  gcloud secrets versions access "${secret_version}"
}

# Main

mkdir secrets
cd secrets
retrieve_secret "${VAULT_SA_CREDENTIALS_SECRET_VERSION}" > vault-sa-credentials
retrieve_secret "${STAN_DB_PASSWORD_SECRET_VERSION}" > stan-db-password
retrieve_secret "${MINIO_SECRET_KEY_SECRET_VERSION}" > minio-secret-key
retrieve_secret "${GW_MONGODB_PASSWORD_SECRET_VERSION}" > gw-mongodb-password

if ! retrieve_secret "${VAULT_ROOT_TOKEN_SECRET_ID}" > vault-root-token; then
  echo "Could not retrieve Vault root token. Vault may not be initialised yet." >&2
fi
