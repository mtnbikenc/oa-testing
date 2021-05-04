#!/usr/bin/env bash
set -euxo pipefail

/oa-testing/cluster/bin/openshift-install \
  create cluster \
  --dir="/oa-testing/cluster/assets" \
  --log-level=debug
