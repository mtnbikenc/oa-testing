#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

pushd ~/git/openshift-ansible/
git diff > "${OPT_CLUSTER_DIR}/sync.patch"
popd
pushd "${OPT_CLUSTER_DIR}/openshift-ansible"
git reset --hard HEAD
git apply ../sync.patch
git status --short
popd
rm "${OPT_CLUSTER_DIR}/sync.patch"
