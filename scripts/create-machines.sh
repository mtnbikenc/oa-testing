#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

# shellcheck source=/dev/null
source "${OPT_CLUSTER_DIR}/ansible/hacking/env-setup"

# Use the extracted `oc` when running playbooks
PATH=${OPT_CLUSTER_DIR}/bin:$PATH
command -v oc

time ${LOCAL_PYTHON} "$(command -v ansible-playbook)" -i "${OPT_CLUSTER_DIR}/inventory/hosts" ../playbooks/create-machines.yml -vvv
