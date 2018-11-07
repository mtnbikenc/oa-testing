#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

${PYTHON} $(which ansible) --version

${PYTHON} $(which ansible-inventory) -i inventory/hosts --list --yaml

playbook_base='openshift-ansible/playbooks/'

echo "### Running OpenShift-Ansible Prerequisites"
if [[ -s "${playbook_base}/prerequisites.yml" ]]; then
    time ${PYTHON} $(which ansible-playbook) -i inventory/hosts ${playbook_base}/prerequisites.yml -vvv
fi
