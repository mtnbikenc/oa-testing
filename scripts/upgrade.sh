#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

ansible --version

ansible-inventory -i inventory/hosts --list --yaml

UPGRADE_VERSION=$(grep -e '^openshift_release:' inventory/group_vars/OSEv3.yml | awk '{ print $2 }' | sed 's/\./_/')

time ansible-playbook -i inventory/hosts openshift-ansible/playbooks/byo/openshift-cluster/upgrades/${UPGRADE_VERSION}/upgrade.yml -vv
