#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

# Extract the installer binary from the release payload
mkdir --parents "${OPT_CLUSTER_DIR}/bin"
pushd "${OPT_CLUSTER_DIR}/bin"
rm --force --verbose ./*
oc adm release extract --tools "${OPT_RELEASE_IMAGE}" --registry-config "${OPT_PULL_SECRET}"
for a in *.tar.gz; do tar -zxvf "$a"; done
# https://www.terraform.io/downloads.html
#wget -q https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip
#unzip ./*.zip
popd
