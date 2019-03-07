#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

ansible-playbook -i localhost, create-install-assets.yml

bin/openshift-install create cluster --dir=./assets --log-level=debug
