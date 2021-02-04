#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup
source build_options.sh

export ANSIBLE_STDOUT_CALLBACK=yaml
export ANSIBLE_INVENTORY="${OPT_CLUSTER_DIR}/${ANSIBLE_INVENTORY}"

pushd "${OPT_CLUSTER_DIR}/${PLAYBOOK_BASE}"
time ${PYTHON} "$(command -v ansible-playbook)" "${PLAYBOOK}" -vv
popd
