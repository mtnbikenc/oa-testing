#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

time ${PYTHON} $(which ansible-playbook) -i localhost, ../playbooks/terminate.yml -vvv -e ansible_python_interpreter=${PYTHON}

rm -f ansible.log
rm -f logs/*.log
