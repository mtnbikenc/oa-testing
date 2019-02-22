#!/usr/bin/env bash
set -euxo pipefail

export KUBECONFIG=/home/rteague/git/oa-testing/aws-40/assets/auth/kubeconfig

# Uncordon CoreOS node
oc adm uncordon $(oc get nodes -o wide | grep worker | grep CoreOS | awk '{print $1}')

# Remove CentOS nodes
oc adm drain $(oc get nodes -o wide | grep CentOS | awk '{print $1}') --force --delete-local-data --ignore-daemonsets --timeout=0s
oc delete machinesets -n openshift-machine-api $(oc get machinesets -n openshift-machine-api | grep centos | awk '{print $1}')
oc delete node $(oc get nodes -o wide | grep CentOS | awk '{print $1}')
