#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

export ANSIBLE_STDOUT_CALLBACK=yaml
ansible-playbook -i "${OPT_CLUSTER_DIR}/inventory/hosts" ../playbooks/prep40.yml -vv
