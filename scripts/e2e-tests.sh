#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

export KUBECONFIG=${OPT_CLUSTER_DIR}/assets/auth/kubeconfig

pushd "${GOPATH}/src/github.com/openshift/openshift-tests"

EXISTING_HASH=$(git rev-parse HEAD)
git reset --hard
git checkout master
git pull --rebase
git fetch --all --tags --prune
git branch | grep -v "master" | xargs git branch -D || true
git checkout "release-${OPT_PAYLOAD}"
CURRENT_HASH=$(git rev-parse HEAD)
if [ "${EXISTING_HASH}" != "${CURRENT_HASH}" ] || [ ! -e "./extended-platform-tests" ]
then
  go build ./cmd/extended-platform-tests
fi

popd

cp "${GOPATH}/src/github.com/openshift/openshift-tests/extended-platform-tests" ./bin
export PATH="${PWD}/bin:$PATH"

./bin/extended-platform-tests run openshift/conformance/parallel
#./bin/extended-platform-tests run -f e2e-failing.txt
