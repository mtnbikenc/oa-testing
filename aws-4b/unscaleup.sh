#!/usr/bin/env bash
set -euxo pipefail

export KUBECONFIG=${PWD}/assets/auth/kubeconfig

# Remove ssh bastion
#oc delete project byoh-ssh-bastion
#oc delete clusterrole ssh-bastion
#oc delete clusterrolebinding ssh-bastion

# Uncordon CoreOS node
COREOS_WORKERS=$(oc get nodes -o wide | grep worker | grep CoreOS | awk '{print $1}' || true)
if [[ ! -z "${COREOS_WORKERS}" ]]
then
    oc adm uncordon ${COREOS_WORKERS}
fi

# Remove CentOS nodes
CENTOS_WORKERS=$(oc get nodes -o wide | grep CentOS | awk '{print $1}' || true)
if [[ ! -z "${CENTOS_WORKERS}" ]]
then
    oc adm drain ${CENTOS_WORKERS} --force --delete-local-data --ignore-daemonsets --timeout=0s
fi

# Remove CentOS machine sets
CENTOS_MACHINE_SETS=$(oc get machinesets -n openshift-machine-api | grep centos | awk '{print $1}' || true)
if [[ ! -z "${CENTOS_MACHINE_SETS}" ]]
then
    oc delete machinesets -n openshift-machine-api ${CENTOS_MACHINE_SETS}
fi

# Remove RHEL nodes
RHEL_WORKERS=$(oc get nodes -o wide | grep "Red Hat Enterprise Linux Server" | awk '{print $1}' || true)
if [[ ! -z "${RHEL_WORKERS}" ]]
then
    oc adm drain ${RHEL_WORKERS} --force --delete-local-data --ignore-daemonsets --timeout=0s
fi

# Remove RHEL machine sets
RHEL_MACHINE_SETS=$(oc get machinesets -n openshift-machine-api | grep rhel | awk '{print $1}' || true)
if [[ ! -z "${RHEL_MACHINE_SETS}" ]]
then
    oc delete machinesets -n openshift-machine-api ${RHEL_MACHINE_SETS}
fi

rm -fv inventory/hosts
