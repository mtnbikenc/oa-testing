#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

ansible --version

ansible-inventory -i inventory/hosts --list --yaml

playbook_base='openshift-ansible/playbooks'

echo "### Running OpenShift-Ansible Node Scaleup ###"
if [[ -s "${playbook_base}/openshift-node/scaleup.yml" ]]; then
    playbook="${playbook_base}/openshift-node/scaleup.yml"
else
    playbook="${playbook_base}/byo/openshift-node/scaleup.yml"
fi

time ansible-playbook -i inventory/hosts ${playbook} -vvv
