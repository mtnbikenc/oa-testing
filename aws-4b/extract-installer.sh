#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

# Extract the installer binary from the release payload
pushd bin
rm -fv o* sha*
oc adm release extract --tools ${OPT_REGISTRY}:${OPT_PAYLOAD} -a ${OPT_PULL_SECRET}
for a in $(ls -1 *.tar.gz); do tar -zxvf $a; done
popd
