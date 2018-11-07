#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

${PYTHON} $(which ansible) --version

${PYTHON} $(which ansible-inventory) -i inventory/hosts --list --yaml

# Pull openshift_release from inventory, grab the second item ("3.10"), change the '.' to a '_',  delete the surrounding quotes
UPGRADE_VERSION=$(grep -e '^openshift_release:' inventory/group_vars/OSEv3.yml | awk '{ print $2 }' | sed -e 's/\./_/' | tr -d \" )

time ${PYTHON} $(which ansible-playbook) -i inventory/hosts openshift-ansible/playbooks/byo/openshift-cluster/upgrades/v${UPGRADE_VERSION}/upgrade.yml -vvv
