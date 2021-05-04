#!/usr/bin/env bash
set -euxo pipefail

# Extract the installer binary from the release payload
mkdir --parents "/oa-testing/cluster/bin"
pushd "/oa-testing/cluster/bin"
rm --force --verbose ./*

oc adm release extract \
  --tools "${OPT_RELEASE_IMAGE}" \
  --to=/oa-testing/cluster/bin \
  --registry-config /oa-testing/pull-secret.txt

sha256sum --check sha256sum.txt
for a in *.tar.gz; do tar -zxvf "$a"; done
popd
