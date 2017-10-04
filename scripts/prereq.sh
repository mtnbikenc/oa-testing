#!/usr/bin/env bash
set -ex

PLAY_TYPE=$(basename -s .sh "$0")
LOG_DATE=$(date "+%FT%H.%M.%S")
export ANSIBLE_LOG_PATH=${LOG_DATE}-${PLAY_TYPE}-ansible.log

playbook_base='openshift-ansible/playbooks/'

echo "### Running OpenShift-Ansible Prerequisites"
if [[ -s "${playbook_base}/prerequisites.yml" ]]; then
    ansible-playbook -i inventory/hosts ${playbook_base}/prerequisites.yml -vv
fi
