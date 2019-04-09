#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

bin/openshift-install destroy cluster --dir=./assets --log-level=debug

rm -f ./assets/.openshift_install*
rm -f ./assets/metadata.json
rm -f ./assets/terraform.tfstate

rm -fv bin/o* bin/sha*

rm -f extra_vars.yml

rm -f logs/*.log
