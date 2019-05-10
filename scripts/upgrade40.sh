#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

${PYTHON} $(which ansible) --version

pushd openshift-ansible

time ${PYTHON} $(which ansible-playbook) -i ../inventory/hosts playbooks/upgrade.yml -vvv

popd
