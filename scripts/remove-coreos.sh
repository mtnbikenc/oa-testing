#!/usr/bin/env bash
set -euxo pipefail

# Remove CoreOS machine sets
echo "$(date -u --rfc-3339=seconds) - Deleting CoreOS machinesets"
mapfile -t COREOS_MACHINE_SETS < <(oc get machinesets --namespace openshift-machine-api | grep worker | grep -v rhel | awk '{print $1}' || true)
if [[ ${#COREOS_MACHINE_SETS[@]} != 0 ]]
then
    oc delete machinesets --namespace openshift-machine-api "${COREOS_MACHINE_SETS[@]}"
fi

echo "$(date -u --rfc-3339=seconds) - Waiting for CoreOS nodes to be removed"
oc wait node \
    --for=delete \
    --timeout=10m \
    --selector node.openshift.io/os_id=rhcos,node-role.kubernetes.io/worker \
    || true

echo "$(date -u --rfc-3339=seconds) - Waiting for worker machineconfig to update"
oc wait machineconfigpool/worker \
  --for=condition=Updated=True \
  --timeout=10m

echo "$(date -u --rfc-3339=seconds) - Waiting for clusteroperators to complete"
oc wait clusteroperator.config.openshift.io \
  --for=condition=Available=True \
  --for=condition=Degraded=False \
  --for=condition=Progressing=False \
  --timeout=10m \
  --all

