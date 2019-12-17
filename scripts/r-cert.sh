#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

${PYTHON} $(which ansible) --version

#${PYTHON} $(which ansible-inventory) -i inventory/hosts --list --yaml

playbook_base='openshift-ansible/playbooks/'

echo "### Running OpenShift-Ansible Redeploy Certificates ###"
if [[ -s "${playbook_base}/redeploy-certificates.yml" ]]; then
    playbook="${playbook_base}redeploy-certificates.yml"
else
    playbook="${playbook_base}byo/openshift-cluster/redeploy-certificates.yml"
fi

time ${PYTHON} $(which ansible-playbook)  -i inventory/hosts ${playbook} -vvv
