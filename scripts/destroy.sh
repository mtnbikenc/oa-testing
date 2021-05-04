#!/usr/bin/env bash
set -euxo pipefail

if [ -f "/oa-testing/cluster/assets/metadata.json" ]
then
  /oa-testing/cluster/bin/openshift-install \
    destroy cluster \
    --dir="/oa-testing/cluster/assets" \
    --log-level=debug
fi

rm -rfv "/oa-testing/cluster/assets/"
rm -rfv "/oa-testing/cluster/bin/"
rm -rfv "/oa-testing/cluster/inventory/"
rm -rfv "/oa-testing/cluster/logs/"
