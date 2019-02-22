#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

# Prepare scale up files and vars
ansible-playbook -i localhost, prep-scaleup.yml -vvv

# Delete the scaleup tasks that remove the CoreOS worker machinesets and nodes
sed -i '/- name: remove existing machinesets/,$d' openshift-ansible/test/aws/scaleup.yml

# Run the scaleup
SCRIPT_TYPE=$(basename -s .sh "$0")
LOG_DATE=$(date "+%FT%H.%M.%S")

export ANSIBLE_CONFIG=${PWD}/openshift-ansible/inventory/dynamic/aws/ansible.cfg

unbuffer ../scripts/node-scaleup40.sh |& tee logs/${LOG_DATE}-${SCRIPT_TYPE}.log
