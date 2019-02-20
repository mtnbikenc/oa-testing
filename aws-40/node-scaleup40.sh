#!/usr/bin/env bash
set -euxo pipefail

# Prepare scale up files and vars
ansible-playbook -i localhost, prep-scaleup.yml -vvv

# Run the scaleup
SCRIPT_TYPE=$(basename -s .sh "$0")
LOG_DATE=$(date "+%FT%H.%M.%S")

export ANSIBLE_CONFIG=${PWD}/openshift-ansible/inventory/dynamic/aws/ansible.cfg

unbuffer ../scripts/node-scaleup40.sh |& tee logs/${LOG_DATE}-${SCRIPT_TYPE}.log
