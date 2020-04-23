#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

export KUBECONFIG=${OPT_CLUSTER_DIR}/assets/auth/kubeconfig

# Uncordon RHEL nodes
mapfile -t RHEL_WORKERS < <(${OC_BIN} get nodes --output wide | grep worker | grep Maipo | awk '{print $1}' || true)
if [[ ${#RHEL_WORKERS[@]} != 0 ]]
then
    ${OC_BIN} adm uncordon "${RHEL_WORKERS[@]}"
fi

# Drain CoreOS nodes
mapfile -t COREOS_WORKERS < <(./bin/oc get nodes --output wide | grep worker | grep CoreOS | awk '{print $1}' || true)
if [[ ${#COREOS_WORKERS[@]} != 0 ]]
then
    ./bin/oc adm drain "${COREOS_WORKERS[@]}" --force --delete-local-data --ignore-daemonsets --timeout=0s
fi

./bin/oc get nodes