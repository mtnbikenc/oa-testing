#!/usr/bin/env bash
set -ex

PLAY_TYPE=$(basename -s .sh "$0")
LOG_DATE=$(date "+%FT%H.%M.%S")
export ANSIBLE_LOG_PATH=${LOG_DATE}-${PLAY_TYPE}-ansible.log

echo "### Running Host Prep ###"
ansible-playbook -i inventory/hosts ../playbooks/prep.yml -vv
