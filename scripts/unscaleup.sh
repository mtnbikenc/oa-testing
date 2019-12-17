#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

export KUBECONFIG=${OPT_CLUSTER_DIR}/assets/auth/kubeconfig

# Remove ssh bastion
#oc delete project byoh-ssh-bastion
#oc delete clusterrole ssh-bastion
#oc delete clusterrolebinding ssh-bastion

# Uncordon CoreOS node
mapfile -t COREOS_WORKERS < <(oc get nodes --output wide | grep worker | grep CoreOS | awk '{print $1}' || true)
if [[ ${#COREOS_WORKERS[@]} != 0 ]]
then
    oc adm uncordon "${COREOS_WORKERS[@]}"
fi

# Remove CentOS nodes
mapfile -t CENTOS_WORKERS < <(oc get nodes --output wide | grep CentOS | awk '{print $1}' || true)
if [[ ${#CENTOS_WORKERS[@]} != 0 ]]
then
    oc adm drain "${CENTOS_WORKERS[@]}" --force --delete-local-data --ignore-daemonsets --timeout=0s
fi

# Remove CentOS machine sets
mapfile -t CENTOS_MACHINE_SETS < <(oc get machinesets -n openshift-machine-api | grep centos | awk '{print $1}' || true)
if [[ ${#CENTOS_MACHINE_SETS[@]} != 0 ]]
then
    oc delete machinesets --namespace openshift-machine-api "${CENTOS_MACHINE_SETS[@]}"
fi

# Remove RHEL nodes
mapfile -t RHEL_WORKERS < <(oc get nodes -o wide | grep "Red Hat Enterprise Linux Server" | awk '{print $1}' || true)
if [[ ${#RHEL_WORKERS[@]} != 0 ]]
then
    oc adm drain "${RHEL_WORKERS[@]}" --force --delete-local-data --ignore-daemonsets --timeout=0s
fi

# Remove RHEL machine sets
mapfile -t RHEL_MACHINE_SETS < <(oc get machinesets --namespace openshift-machine-api | grep rhel | awk '{print $1}' || true)
if [[ ${#RHEL_MACHINE_SETS[@]} != 0 ]]
then
    oc delete machinesets --namespace openshift-machine-api "${RHEL_MACHINE_SETS[@]}"
fi

rm --force --verbose "${OPT_CLUSTER_DIR}/inventory/hosts"
