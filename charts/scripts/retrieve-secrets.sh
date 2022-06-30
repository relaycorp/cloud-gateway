#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

# Constants and functions

retrieve_secret_version() {
  local secret_version="$1"

  gcloud secrets versions access "${secret_version}"
}

# Main

mkdir secrets
cd secrets
retrieve_secret_version "${STAN_DB_PASSWORD_SECRET_VERSION}" >stan-db-password
retrieve_secret_version "${GW_MONGODB_PASSWORD_SECRET_VERSION}" >gw-mongodb-password
