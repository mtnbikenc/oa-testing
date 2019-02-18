#!/usr/bin/env bash
set -euxo pipefail

pushd ${GOPATH}/src/github.com/openshift/installer

git checkout master
git pull --rebase
git fetch --all --tags --prune
# Checkout the latest tag
#git checkout $(git describe --tags $(git rev-list --tags --max-count=1))

hack/build.sh

popd

cp ${GOPATH}/src/github.com/openshift/installer/bin/openshift-install ./bin/

rm -Rf assets/* assets/.openshift*

cp ./install-config.yaml ./assets/

export AWS_PROFILE="openshift-dev"

bin/openshift-install create cluster --dir=./assets --log-level=debug
