#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

export KUBECONFIG=${PWD}/assets/auth/kubeconfig
SSH_BASTION=$(oc get service -n byoh-ssh-bastion ssh-bastion -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# Generate hosts list
echo '[workers]' > inventory/hosts
oc get nodes -o wide | grep worker | grep -v CoreOS | awk '{print $1}' >> inventory/hosts

# Add openshift_kubeconfig_path to all hosts (including localhost)
mkdir -p inventory/group_vars/all
echo "openshift_kubeconfig_path: \"${PWD}/assets/auth/kubeconfig\"" > inventory/group_vars/all/vars.yml

# Add centos user to workers
mkdir -p inventory/group_vars/workers
echo "ansible_user: \"centos\"" > inventory/group_vars/workers/vars.yml
echo "ansible_become: true" >> inventory/group_vars/workers/vars.yml

# Add ssh_bastion to workers
echo "ansible_ssh_common_args: \"-o ProxyCommand=\\\"ssh -o IdentityFile='${OPT_PRIVATE_KEY}' -o StrictHostKeyChecking=no -W %h:%p -q core@${SSH_BASTION}\\\"\"" >> inventory/group_vars/workers/vars.yml

# Run the scaleup
SCRIPT_TYPE=$(basename -s .sh "$0")
LOG_DATE=$(date "+%FT%H.%M.%S")

export ANSIBLE_CONFIG=${PWD}/openshift-ansible/inventory/dynamic/aws/ansible.cfg

unbuffer ../scripts/upgrade40.sh |& tee logs/${LOG_DATE}-${SCRIPT_TYPE}.log
