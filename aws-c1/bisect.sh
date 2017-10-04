#!/usr/bin/env bash
set -e

cd ansible
git submodule update --init --recursive
source hacking/env-setup
cd ..
#ansible-playbook -i inventory/hosts openshift-ansible/playbooks/byo/config.yml -vv --syntax-check
#ansible-playbook -i test-inv test.yml | tee /dev/stderr | grep "NO MORE HOSTS LEFT"
ansible-playbook -i test-inv test-fail.yml -e nodes_serial=4 -e nodes_max_fail_percentage=30 | tee /dev/stderr | grep "host10"
