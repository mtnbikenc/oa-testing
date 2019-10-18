#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

${PYTHON} $(which ansible) --version

#${PYTHON} $(which ansible-inventory) -i inventory/hosts --list --yaml

playbook_base='openshift-ansible/playbooks/'

echo "### Running OpenShift-Ansible Deploy ###"
playbook="${playbook_base}/openshift-checks/certificate_expiry/easy-mode.yaml"

#export ANSIBLE_CALLBACK_PLUGINS="$(python3 -m ara.setup.callback_plugins)"


time ${PYTHON} $(which ansible-playbook)  -e "openshift_certificate_expiry_generate_html_report=yes" -i inventory/hosts ${playbook} -vvv
