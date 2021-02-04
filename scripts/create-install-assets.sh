#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh
export ANSIBLE_STDOUT_CALLBACK=yaml

ansible-playbook -i localhost, ../playbooks/create-install-assets.yml -vv
