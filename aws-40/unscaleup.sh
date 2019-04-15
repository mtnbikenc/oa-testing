#!/usr/bin/env bash
set -euxo pipefail

export KUBECONFIG=${PWD}/assets/auth/kubeconfig

# Remove ssh bastion
#oc delete project byoh-ssh-bastion
#oc delete clusterrole ssh-bastion
#oc delete clusterrolebinding ssh-bastion

# Uncordon CoreOS node
COREOS_WORKERS=$(oc get nodes -o wide | grep worker | grep CoreOS | awk '{print $1}')
if [ ! -z "${COREOS_WORKERS}" ]
then
    oc adm uncordon ${COREOS_WORKERS}
fi

# Remove CentOS nodes
CENTOS_WORKERS=$(oc get nodes -o wide | grep CentOS | awk '{print $1}')
if [ ! -z "${CENTOS_WORKERS}" ]
then
    oc adm drain ${CENTOS_WORKERS} --force --delete-local-data --ignore-daemonsets --timeout=0s
    oc delete machinesets -n openshift-machine-api $(oc get machinesets -n openshift-machine-api | grep centos | awk '{print $1}')
fi
