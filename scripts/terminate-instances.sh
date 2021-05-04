#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

export ANSIBLE_STDOUT_CALLBACK=community.general.yaml
export ANSIBLE_CONFIG="/oa-testing/playbooks/ansible.cfg"
export ANSIBLE_INVENTORY="/oa-testing/playbooks/inventory/hosts"

../runner/runner.sh \
  ansible-playbook \
  -vv \
  "/oa-testing/playbooks/terminate.yml"

rm -rfv "${OPT_LOCAL_DIR}/assets/"
rm -rfv "logs/"
