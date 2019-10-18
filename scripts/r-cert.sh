#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

${PYTHON} $(which ansible) --version

#${PYTHON} $(which ansible-inventory) -i inventory/hosts --list --yaml

playbook_base='openshift-ansible/playbooks/'

echo "### Running OpenShift-Ansible Deploy ###"
playbook="${playbook_base}/redeploy-certificates.yml"

#export ANSIBLE_CALLBACK_PLUGINS="$(python3 -m ara.setup.callback_plugins)"


time ${PYTHON} $(which ansible-playbook)  -i inventory/hosts ${playbook} -vvv
