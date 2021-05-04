#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

if [ -f "${OPT_LOCAL_DIR}/inventory/aws_vpc.json" ]
then
  aws cloudformation delete-stack --stack-name "${OPT_CLUSTER_ID}"
  aws cloudformation wait stack-delete-complete --stack-name "${OPT_CLUSTER_ID}"
  rm -rfv "${OPT_LOCAL_DIR}/inventory/aws_vpc.json"
fi
