#!/usr/bin/env bash
set -euxo pipefail

./compile-installer.sh

source build_options.sh

ansible-playbook -i localhost, create-install-assets.yml

export OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE=registry.svc.ci.openshift.org/openshift/origin-release:v4.0

bin/openshift-install create cluster --dir=./assets --log-level=debug
