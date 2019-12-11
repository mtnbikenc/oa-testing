#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

ansible-playbook -i "${OPT_CLUSTER_DIR}/inventory/hosts" ../playbooks/prep40.yml -vvv
