#!/usr/bin/env bash
set -euxo pipefail

export AWS_PROFILE="openshift-dev"

bin/openshift-install destroy cluster --dir=./assets --log-level=debug

rm -f ./assets/.openshift_install*
