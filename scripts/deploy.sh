#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

${PYTHON} $(which ansible) --version

${PYTHON} $(which ansible-inventory) -i inventory/hosts --list --yaml

playbook_base='openshift-ansible/playbooks/'

echo "### Running OpenShift-Ansible Deploy ###"
if [[ -s "${playbook_base}/deploy_cluster.yml" ]]; then
    playbook="${playbook_base}deploy_cluster.yml"
else
    playbook="${playbook_base}byo/config.yml"
fi

time ${PYTHON} $(which ansible-playbook) -i inventory/hosts ${playbook} -vvv
