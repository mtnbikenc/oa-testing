#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

# Extract the installer binary from the release payload
mkdir -p "${OPT_CLUSTER_DIR}/bin"
cd "${OPT_CLUSTER_DIR}/bin"
rm -fv o* sha*
oc adm release extract --tools "${OPT_REGISTRY}":"${OPT_PAYLOAD}" -a "${OPT_PULL_SECRET}"
for a in *.tar.gz; do tar -zxvf "$a"; done
