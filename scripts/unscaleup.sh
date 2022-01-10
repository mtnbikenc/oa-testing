#!/usr/bin/env bash
set -euxo pipefail

# Remove ssh bastion
#oc delete project test-ssh-bastion
#oc delete clusterrole ssh-bastion
#oc delete clusterrolebinding ssh-bastion

# Uncordon CoreOS nodes
mapfile -t COREOS_WORKERS < <(oc get nodes --output wide | grep worker | grep CoreOS | awk '{print $1}' || true)
if [[ ${#COREOS_WORKERS[@]} != 0 ]]
then
    oc adm uncordon "${COREOS_WORKERS[@]}"
fi

# Drain CentOS nodes
mapfile -t CENTOS_WORKERS < <(oc get nodes --output wide | grep worker | grep CentOS | awk '{print $1}' || true)
if [[ ${#CENTOS_WORKERS[@]} != 0 ]]
then
    oc adm drain "${CENTOS_WORKERS[@]}" --force --delete-emptydir-data --ignore-daemonsets --timeout=0s
fi

# Remove CentOS machine sets
mapfile -t CENTOS_MACHINE_SETS < <(oc get machinesets -n openshift-machine-api | grep centos | awk '{print $1}' || true)
if [[ ${#CENTOS_MACHINE_SETS[@]} != 0 ]]
then
    oc delete machinesets --namespace openshift-machine-api "${CENTOS_MACHINE_SETS[@]}"
fi

# Drain RHEL nodes
mapfile -t RHEL_WORKERS < <(oc get nodes -o wide | grep worker | grep -v CoreOS | awk '{print $1}' || true)
if [[ ${#RHEL_WORKERS[@]} != 0 ]]
then
    oc adm drain "${RHEL_WORKERS[@]}" --force --delete-emptydir-data --ignore-daemonsets --timeout=0s
fi

# Remove RHEL machine sets
mapfile -t RHEL_MACHINE_SETS < <(oc get machinesets --namespace openshift-machine-api | grep rhel | awk '{print $1}' || true)
if [[ ${#RHEL_MACHINE_SETS[@]} != 0 ]]
then
    oc delete machinesets --namespace openshift-machine-api "${RHEL_MACHINE_SETS[@]}"
fi

# Delete RHEL nodes (nodes not part of machinesets will not be automatically deleted)
mapfile -t RHEL_WORKERS < <(oc get nodes --output wide | grep worker | grep -v CoreOS | awk '{print $1}' || true)
if [[ ${#RHEL_WORKERS[@]} != 0 ]]
then
    oc delete node "${RHEL_WORKERS[@]}"
fi

# Wait for nodes to be deleted
oc wait node \
    --for=delete \
    --timeout=10m \
    --selector node.openshift.io/os_id=rhel,node-role.kubernetes.io/worker \
    || true

RHEL_MACHINE_SETS_JOINED=$(printf -v var '%s,' "${RHEL_MACHINE_SETS[@]}"; echo "${var%,}")

# Wait for machines to be deleted
oc wait machine \
    --for=delete \
    --timeout=10m \
    --namespace openshift-machine-api \
    --selector "machine.openshift.io/cluster-api-machineset in (${RHEL_MACHINE_SETS_JOINED})" \
    || true

export ANSIBLE_STDOUT_CALLBACK="community.general.yaml"
export ANSIBLE_CONFIG="/oa-testing/playbooks/ansible.cfg"
export ANSIBLE_LOG_PATH="/oa-testing/cluster/logs/ansible.log"
export ANSIBLE_INVENTORY="/oa-testing/playbooks/inventory/hosts"

ansible-playbook \
  -vv \
  /oa-testing/playbooks/terminate-instances.yml

rm --force --verbose "/oa-testing/cluster/inventory/hosts"
