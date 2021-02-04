#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh
export ANSIBLE_STDOUT_CALLBACK=yaml
time ansible-playbook -i localhost, ../playbooks/terminate.yml -vv -e "ansible_python_interpreter=${PYTHON}"

rm -rfv ansible.log
rm -rfv "${OPT_CLUSTER_DIR}/assets/"
rm -rfv "logs/"
