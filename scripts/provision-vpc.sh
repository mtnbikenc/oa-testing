#!/usr/bin/env bash
set -euxo pipefail

if [ ! -f "inventory/aws_vpc.json" ]
then
  aws cloudformation create-stack --stack-name "${OPT_CLUSTER_ID}" \
    --template-body "file://../scripts/vpc/vpc-template.yaml" \
    --parameters "file://../scripts/vpc/vpc-parameters.json"

  aws cloudformation wait stack-create-complete --stack-name "${OPT_CLUSTER_ID}"

  aws cloudformation describe-stacks --stack-name "${OPT_CLUSTER_ID}" --output json > inventory/aws_vpc.json
fi

