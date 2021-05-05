#!/usr/bin/env bash
set -euxo pipefail

if [ -f "inventory/aws_vpc.json" ]
then
  aws cloudformation delete-stack --stack-name "${OPT_CLUSTER_ID}"
  aws cloudformation wait stack-delete-complete --stack-name "${OPT_CLUSTER_ID}"
  rm -rfv "inventory/aws_vpc.json"
fi

rm -rfv "assets/"
rm -rfv "logs/"
