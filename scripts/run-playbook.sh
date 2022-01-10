#!/usr/bin/env bash
set -euxo pipefail

export ANSIBLE_STDOUT_CALLBACK="community.general.yaml"

time ansible-playbook -vv "${OPT_PLAYBOOK_BASE}/${OPT_PLAYBOOK}"
