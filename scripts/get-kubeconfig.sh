#!/usr/bin/env bash
set -euxo pipefail

REMOTEHOST=$(ansible-inventory -i "/oa-testing/cluster/inventory/hosts" --list | jq -r '.masters.hosts[0]')
REMOTEUSER=$(ansible-inventory -i "/oa-testing/cluster/inventory/hosts" --list | jq -r --arg remotehost "$REMOTEHOST" '._meta.hostvars | .[$remotehost] | .ansible_user')
mkdir --parents "/oa-testing/cluster/assets/auth"
ssh -o IdentityFile=/oa-testing/openshift-dev.pem -o StrictHostKeyChecking=no "${REMOTEUSER}@${REMOTEHOST}" "sudo cat /etc/origin/master/admin.kubeconfig" > "/oa-testing/cluster/assets/auth/kubeconfig"
