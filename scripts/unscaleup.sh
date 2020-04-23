#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

export KUBECONFIG=${OPT_CLUSTER_DIR}/assets/auth/kubeconfig
export OC_BIN=./bin/oc

# Remove ssh bastion
#${OC_BIN} delete project test-ssh-bastion
#${OC_BIN} delete clusterrole ssh-bastion
#${OC_BIN} delete clusterrolebinding ssh-bastion

# Uncordon CoreOS nodes
mapfile -t COREOS_WORKERS < <(${OC_BIN} get nodes --output wide | grep worker | grep CoreOS | awk '{print $1}' || true)
if [[ ${#COREOS_WORKERS[@]} != 0 ]]
then
    ${OC_BIN} adm uncordon "${COREOS_WORKERS[@]}"
fi

# Drain CentOS nodes
mapfile -t CENTOS_WORKERS < <(${OC_BIN} get nodes --output wide | grep CentOS | awk '{print $1}' || true)
if [[ ${#CENTOS_WORKERS[@]} != 0 ]]
then
    ${OC_BIN} adm drain "${CENTOS_WORKERS[@]}" --force --delete-local-data --ignore-daemonsets --timeout=0s
fi

# Remove CentOS machine sets
mapfile -t CENTOS_MACHINE_SETS < <(${OC_BIN} get machinesets -n openshift-machine-api | grep centos | awk '{print $1}' || true)
if [[ ${#CENTOS_MACHINE_SETS[@]} != 0 ]]
then
    ${OC_BIN} delete machinesets --namespace openshift-machine-api "${CENTOS_MACHINE_SETS[@]}"
fi

# Drain RHEL nodes
mapfile -t RHEL_WORKERS < <(${OC_BIN} get nodes -o wide | grep "Red Hat Enterprise Linux Server" | awk '{print $1}' || true)
if [[ ${#RHEL_WORKERS[@]} != 0 ]]
then
    ${OC_BIN} adm drain "${RHEL_WORKERS[@]}" --force --delete-local-data --ignore-daemonsets --timeout=0s
fi

# Remove RHEL machine sets
mapfile -t RHEL_MACHINE_SETS < <(${OC_BIN} get machinesets --namespace openshift-machine-api | grep rhel | awk '{print $1}' || true)
if [[ ${#RHEL_MACHINE_SETS[@]} != 0 ]]
then
    ${OC_BIN} delete machinesets --namespace openshift-machine-api "${RHEL_MACHINE_SETS[@]}"
fi

# Delete RHEL nodes (nodes not part of machinesets will not be automatically deleted)
mapfile -t RHEL_WORKERS < <(${OC_BIN} get nodes --output wide | grep worker | grep "Red Hat Enterprise Linux Server" | awk '{print $1}' || true)
if [[ ${#RHEL_WORKERS[@]} != 0 ]]
then
    ${OC_BIN} delete node "${RHEL_WORKERS[@]}"
fi

time ansible-playbook -i localhost, ../playbooks/terminate.yml -vvv -e ansible_python_interpreter=${LOCAL_PYTHON}

rm --force --verbose "${OPT_CLUSTER_DIR}/inventory/hosts"
