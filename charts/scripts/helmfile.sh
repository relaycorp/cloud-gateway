#!/bin/bash

# Bypass the helmfile wrapper in the community builder with something reliable.
# Works around https://github.com/GoogleCloudPlatform/cloud-builders-community/pull/462
# and other issues.

set -o nounset
set -o errexit
set -o pipefail

# Make `gcloud` available where the kube config expects to find it
mkdir -p /usr/lib/google-cloud-sdk/bin
ln -s /builder/google-cloud-sdk/bin/gcloud /usr/lib/google-cloud-sdk/bin/gcloud

exec helmfile "$@"
