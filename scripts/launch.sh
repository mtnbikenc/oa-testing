#!/usr/bin/env bash
set -ex

if [ ! -f aws.dat ]; then
    echo "Launching..."
    ../../aos-ansible/bin/aws-launcher launch \
        -m ${OPT_MASTER_COUNT} \
        -n ${OPT_NODE_COUNT} \
        -u ${OPT_CLUSTER_ID} \
        --instance-type=${OPT_INSTANCE_TYPE}
    cp hosts inventory/
else
    echo "aws.dat exists, skipping launch"
fi
