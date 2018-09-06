#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

pushd inventory

if [ ! -f aws.dat ]; then
    ../../../aos-ansible/bin/aws-launcher launch \
        -m ${OPT_MASTER_COUNT} \
        -n ${OPT_COMPUTE_COUNT} \
        -u ${OPT_CLUSTER_ID} \
        --instance-type=${OPT_INSTANCE_TYPE}
else
    echo "aws.dat exists, skipping launch"
fi
