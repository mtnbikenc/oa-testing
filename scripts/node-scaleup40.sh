#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

${PYTHON} $(which ansible) --version

pushd openshift-ansible

time ${PYTHON} $(which ansible-playbook) -i inventory/dynamic/aws/ test/aws/scaleup.yml -e @../extra_vars.yml -vvv

popd
