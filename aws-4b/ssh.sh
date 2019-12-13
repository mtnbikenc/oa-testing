#!/usr/bin/env bash
#set -euxo pipefail

# Connects to a remote host selected from an Ansible inventory using an ssh bastion
#
# Usage:
# $ ./ssh.sh <int>
# <int> is the 0 ordered index number of the host you want to connect to

source build_options.sh

REMOTEHOST=$(ansible-inventory -i "${OPT_CLUSTER_DIR}/inventory/hosts" --list | jq --argjson index "$1" -r '.new_workers.hosts[$index]')
REMOTEUSER=$(ansible-inventory -i "${OPT_CLUSTER_DIR}/inventory/hosts" --list | jq -r --arg remotehost "$REMOTEHOST" '._meta.hostvars | .[$remotehost] | .ansible_user')

export KUBECONFIG=${OPT_CLUSTER_DIR}/assets/auth/kubeconfig
BASTION=$(oc get service -n byoh-ssh-bastion ssh-bastion -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
export BASTION

ssh -o IdentityFile="${OPT_PRIVATE_KEY}" -o StrictHostKeyChecking=no -o ProxyCommand='ssh -A -o StrictHostKeyChecking=no -o ServerAliveInterval=30 -W %h:%p core@${BASTION}' "${REMOTEUSER}"@"${REMOTEHOST}"
