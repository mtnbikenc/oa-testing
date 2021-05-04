#!/usr/bin/env bash
set -euxo pipefail

# Uncordon RHEL nodes
mapfile -t RHEL_WORKERS < <(oc get nodes --output wide | grep worker | grep Maipo | awk '{print $1}' || true)
if [[ ${#RHEL_WORKERS[@]} != 0 ]]
then
    oc adm uncordon "${RHEL_WORKERS[@]}"
fi

# Drain CoreOS nodes
mapfile -t COREOS_WORKERS < <(oc get nodes --output wide | grep worker | grep CoreOS | awk '{print $1}' || true)
if [[ ${#COREOS_WORKERS[@]} != 0 ]]
then
    oc adm drain "${COREOS_WORKERS[@]}" --force --delete-emptydir-data --ignore-daemonsets --timeout=0s
fi

oc get nodes