#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

time ansible-playbook -i inventory/hosts ../playbooks/prep.yml -vvv
