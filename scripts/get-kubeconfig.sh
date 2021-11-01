#!/usr/bin/env bash
set -euxo pipefail

REMOTE_HOST=$(ansible-inventory -i "/oa-testing/cluster/inventory/hosts" --list | jq -r '.masters.hosts[0]')
REMOTE_USER=$(ansible-inventory -i "/oa-testing/cluster/inventory/hosts" --list | jq -r --arg REMOTE_HOST "$REMOTE_HOST" '._meta.hostvars | .[$REMOTE_HOST] | .ansible_user')
mkdir --parents "/oa-testing/cluster/assets/auth"
ssh -o IdentityFile=/oa-testing/cluster/assets/auth/id_ssh_rsa -o StrictHostKeyChecking=no "${REMOTE_USER}@${REMOTE_HOST}" "sudo cat /etc/origin/master/admin.kubeconfig" > "/oa-testing/cluster/assets/auth/kubeconfig"
