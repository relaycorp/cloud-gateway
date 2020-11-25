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
retrieve_secret "${VAULT_SA_CREDENTIALS_SECRET_VERSION}" > secrets/vault-sa-credentials
retrieve_secret "${STAN_DB_PASSWORD_SECRET_VERSION}" > secrets/stan-db-password
