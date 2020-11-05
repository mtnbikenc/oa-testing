#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

time ansible-playbook -i localhost, ../playbooks/terminate.yml -vvv -e "ansible_python_interpreter=${PYTHON}"

rm -rfv ansible.log
rm -rfv "${OPT_CLUSTER_DIR}/assets/"
rm -rfv "logs/"
