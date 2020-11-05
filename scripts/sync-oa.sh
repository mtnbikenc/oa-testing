#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

pushd ~/git/openshift-ansible/
git add .
git diff --staged > "${OPT_CLUSTER_DIR}/sync.patch"
git restore --staged .
popd
pushd "${OPT_CLUSTER_DIR}/openshift-ansible"
git reset --hard HEAD
git clean -fdx
git apply ../sync.patch
git status --short
popd
rm "${OPT_CLUSTER_DIR}/sync.patch"
