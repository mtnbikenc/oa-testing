#!/usr/bin/env bash
set -euo pipefail

# Create an array of hosts from the Ansible inventory
IFS=" " read -r -a HOST_LIST <<< "$(ansible all -i "/oa-testing/cluster/inventory/hosts" --list-hosts | tail -n +2 | xargs)"

printf "\nChoose from the following hosts:\n"
for i in "${!HOST_LIST[@]}"; do
  printf "  %s  %s\n" "$i" "${HOST_LIST[$i]}"
done

read -rp 'Choice [0]: ' HOST_INDEX
HOST_INDEX=${HOST_INDEX:-"0"}
REMOTE_HOST="${HOST_LIST[HOST_INDEX]}"
REMOTE_USER=$(ansible-inventory -i "/oa-testing/cluster/inventory/hosts" --list | jq -r --arg REMOTE_HOST "$REMOTE_HOST" '._meta.hostvars | .[$REMOTE_HOST] | .ansible_user')

export KUBECONFIG=/oa-testing/cluster/assets/auth/kubeconfig
BASTION=$(oc get service -n test-ssh-bastion ssh-bastion -o jsonpath="{.status.loadBalancer.ingress[0].hostname}") || true

if [ -n "${BASTION}" ]; then
  # With bastion
  set -x
  ssh -o IdentityFile="/oa-testing/cluster/assets/auth/id_ssh_rsa" -o StrictHostKeyChecking=no -o "ProxyCommand=ssh -o IdentityFile=/oa-testing/cluster/assets/auth/id_ssh_rsa -o StrictHostKeyChecking=no -o ServerAliveInterval=30 -W %h:%p core@${BASTION}" "${REMOTE_USER}"@"${REMOTE_HOST}"
else
  set -x
  ssh -o IdentityFile="/oa-testing/cluster/assets/auth/id_ssh_rsa" -o StrictHostKeyChecking=no "${REMOTE_USER}"@"${REMOTE_HOST}"
fi
