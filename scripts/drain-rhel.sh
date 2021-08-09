#!/usr/bin/env bash
set -euxo pipefail

# Uncordon CoreOS nodes
mapfile -t COREOS_WORKERS < <(oc get nodes --output wide | grep worker | grep CoreOS | awk '{print $1}' || true)
if [[ ${#COREOS_WORKERS[@]} != 0 ]]
then
    oc adm uncordon "${COREOS_WORKERS[@]}"
fi

# Drain RHEL nodes
mapfile -t RHEL_WORKERS < <(oc get nodes --output wide | grep worker | grep -v CoreOS | awk '{print $1}' || true)
if [[ ${#RHEL_WORKERS[@]} != 0 ]]
then
    oc adm drain "${RHEL_WORKERS[@]}" --force --delete-emptydir-data --ignore-daemonsets --timeout=0s
fi

oc get nodes