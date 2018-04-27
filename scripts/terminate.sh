#!/usr/bin/env bash
set -euxo pipefail

if [ -f inventory/aws.dat ]; then
    pushd inventory
    ../../../aos-ansible/bin/aws-launcher terminate
    popd
fi

rm -f ansible.log
rm -f logs/*.log
