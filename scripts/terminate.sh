#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

time ansible-playbook -i localhost, ../playbooks/terminate.yml -vv

rm -f ansible.log
rm -f logs/*.log
