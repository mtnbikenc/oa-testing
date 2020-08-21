#!/usr/bin/env bash
set -euxo pipefail

pushd "${GOPATH}/src/github.com/openshift/installer"

git describe
git --no-pager log --oneline -5

hack/build.sh

popd

mkdir -p ./bin/
cp "${GOPATH}/src/github.com/openshift/installer/bin/openshift-install" ./bin/
