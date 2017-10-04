#!/usr/bin/env bash
set -ex

PLAY_TYPE=$(basename -s .sh "$0")
LOG_DATE=$(date "+%FT%H.%M.%S")
export ANSIBLE_LOG_PATH=${LOG_DATE}-${PLAY_TYPE}-ansible.log

playbook_base='openshift-ansible/playbooks/'

echo "### Running OpenShift-Ansible Deploy ###"
if [[ -s "${playbook_base}/deploy_cluster.yml" ]]; then
    playbook="${playbook_base}deploy_cluster.yml"
else
    playbook="${playbook_base}byo/config.yml"
fi

time ansible-playbook -i inventory/hosts ${playbook} -vv
