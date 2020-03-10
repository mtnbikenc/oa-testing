#!/usr/bin/env bash
set -euxo pipefail

source ansible/hacking/env-setup

source build_options.sh

playbook_base='openshift-ansible/playbooks/'

playbook="${playbook_base}openshift-logging/config.yml"

time ${PYTHON} "$(command -v ansible-playbook)"  -i inventory/hosts ${playbook} -vvv
