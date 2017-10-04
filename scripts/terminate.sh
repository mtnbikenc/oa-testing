#!/usr/bin/env bash
set -x

../../aos-ansible/bin/aws-launcher terminate

if [ -f inventory/hosts ]; then
    rm inventory/hosts
fi

rm -f *ansible.log
