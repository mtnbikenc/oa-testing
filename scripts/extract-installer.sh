#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

# Extract the installer binary from the release payload
mkdir --parents "${OPT_CLUSTER_DIR}/bin"
pushd "${OPT_CLUSTER_DIR}/bin"
rm --force --verbose o* sha*
oc adm release extract --tools "${OPT_REGISTRY}":"${OPT_PAYLOAD}" -a "${OPT_PULL_SECRET}"
for a in *.tar.gz; do tar -zxvf "$a"; done
popd
