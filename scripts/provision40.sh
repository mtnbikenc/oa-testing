#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

# shellcheck source=/dev/null
source "${OPT_CLUSTER_DIR}/ansible/hacking/env-setup"
export ANSIBLE_STDOUT_CALLBACK=yaml
time ${LOCAL_PYTHON} "$(command -v ansible-playbook)" -i localhost, ../playbooks/provision40.yml -vv -e "ansible_python_interpreter=${LOCAL_PYTHON}"
