#!/bin/bash

# Bypass the helmfile wrapper in the community builder with something reliable.
# Works around https://github.com/GoogleCloudPlatform/cloud-builders-community/pull/462
# and other issues.

set -o nounset
set -o errexit
set -o pipefail

# Configuration

HELM_DIFF_VERSION="3.1.3"
KUSTOMIZE_VERSION="3.8.7"

# Constants and functions

KUSTOMIZE_URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz"

# Main

# Make `gcloud` available where the kube config expects to find it
mkdir -p /usr/lib/google-cloud-sdk/bin
ln -s /builder/google-cloud-sdk/bin/gcloud /usr/lib/google-cloud-sdk/bin/gcloud

if helm plugin list | grep -E '^diff\s' --quiet; then
  echo "Helm Diff is already installed (presumably because ${BASH_SOURCE[0]} was run earlier)"
else
  echo "Installing Helm Diff..."
  helm plugin install https://github.com/databus23/helm-diff --version "${HELM_DIFF_VERSION}" \
    >>/dev/null
fi

if which kustomize >>/dev/null ; then
  echo "Kustomize is already installed"
else
  echo "Installing Kustomize..."
  curl --location --silent "${KUSTOMIZE_URL}" | tar --extract --gzip --directory=/builder/helmfile/
fi

helmfile "$@"

# helmfile ignores hook errors so we have to implement our own error handling :(
# See: https://github.com/roboll/helmfile/issues/1272 and
# https://github.com/roboll/helmfile/issues/764
if [[ -f /tmp/failed-helmfile-hooks ]]; then
  echo "The following helmfile hooks failed:" >&2
  cat >&2 < /tmp/failed-helmfile-hooks
  exit 1
fi
