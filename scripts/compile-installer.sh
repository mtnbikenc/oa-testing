#!/usr/bin/env bash
set -euxo pipefail

pushd ${GOPATH}/src/github.com/openshift/installer

git checkout master
git pull --rebase
git fetch --all --tags --prune
# Checkout the latest tag
# 0.15.0 is broken, using master
#git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
git describe
git --no-pager log --oneline -5

hack/build.sh

popd

cp ${GOPATH}/src/github.com/openshift/installer/bin/openshift-install ./bin/
