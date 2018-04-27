#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

playbook_base='openshift-ansible/playbooks/'

echo "### Running OpenShift-Ansible Prerequisites"
if [[ -s "${playbook_base}/prerequisites.yml" ]]; then
    ansible-playbook -i inventory/hosts ${playbook_base}/prerequisites.yml -vv
fi
