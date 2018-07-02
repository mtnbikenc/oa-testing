#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

ansible --version

ansible-inventory -i inventory/hosts --list --yaml

time ansible-playbook -i inventory/hosts openshift-ansible/playbooks/openshift-node/scaleup.yml -vv
