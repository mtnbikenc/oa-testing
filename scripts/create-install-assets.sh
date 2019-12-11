#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

ansible-playbook -i localhost, ../playbooks/create-install-assets.yml -vvv
