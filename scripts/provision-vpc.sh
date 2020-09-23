#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

if [ ! -f "${OPT_CLUSTER_DIR}/inventory/aws_vpc.json" ]
then
  aws cloudformation create-stack --stack-name "${OPT_CLUSTER_ID}" \
    --template-body "file://${OPT_CLUSTER_DIR}/../scripts/vpc/vpc-template.yaml" \
    --parameters "file://${OPT_CLUSTER_DIR}/../scripts/vpc/vpc-parameters.json"

  aws cloudformation wait stack-create-complete --stack-name "${OPT_CLUSTER_ID}"

  aws cloudformation describe-stacks --stack-name "${OPT_CLUSTER_ID}" > inventory/aws_vpc.json
fi

