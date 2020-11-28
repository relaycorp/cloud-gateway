#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

CRDS_DIR="$(dirname "${BASH_SOURCE[0]}")/crds"

echo "Applying CRDs..."
kubectl apply --filename="${CRDS_DIR}" --wait
