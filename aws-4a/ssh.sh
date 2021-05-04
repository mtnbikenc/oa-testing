#!/usr/bin/env bash
set -euo pipefail

# Connects to a remote host selected from an Ansible inventory using an ssh bastion
#
# Usage:
# $ ./ssh.sh <int>
# <int> is the 0 ordered index number of the host you want to connect to

source build_options.sh

REMOTEHOST=$(ansible-inventory -i "${OPT_LOCAL_DIR}/inventory/hosts" --list | jq --argjson index "$1" -r '.new_workers.hosts[$index]')
REMOTEUSER=$(ansible-inventory -i "${OPT_LOCAL_DIR}/inventory/hosts" --list | jq -r --arg remotehost "$REMOTEHOST" '._meta.hostvars | .[$remotehost] | .ansible_user')

export KUBECONFIG=${OPT_LOCAL_DIR}/assets/auth/kubeconfig
BASTION=$(oc get service -n test-ssh-bastion ssh-bastion -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

set -x
ssh -o IdentityFile="${OPT_LOCAL_PRIVATE_KEY}" -o StrictHostKeyChecking=no -o "ProxyCommand=ssh -o IdentityFile=${OPT_LOCAL_PRIVATE_KEY} -o StrictHostKeyChecking=no -o ServerAliveInterval=30 -W %h:%p core@${BASTION}" "${REMOTEUSER}"@"${REMOTEHOST}"
