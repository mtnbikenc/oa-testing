#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

echo "### Updating git clone of openshift-ansible ###"
unset GIT_DIR
unset GIT_WORK_TREE
if [ ! -d openshift-ansible ]; then
    git clone https://github.com/openshift/openshift-ansible
else
    export GIT_DIR=${PWD}/openshift-ansible/.git
    export GIT_WORK_TREE=${PWD}/openshift-ansible
    if [ -d ${GIT_DIR}/rebase-apply ]; then
        rm -rf ${GIT_DIR}/rebase-apply
    fi
    git reset --hard
    git clean -fdx
    git checkout master
    git pull --rebase
    git fetch --tags --prune
    git branch | grep -v "master" | xargs git branch -D || true
fi
export GIT_DIR=${PWD}/openshift-ansible/.git
export GIT_WORK_TREE=${PWD}/openshift-ansible

# Checkout a pull request
if [ -v OPT_OA_PRNUM ]; then
    git fetch origin pull/${OPT_OA_PRNUM}/merge:PR${OPT_OA_PRNUM}
    git checkout PR${OPT_OA_PRNUM}
fi

# Checkout a tag
if [ -v OPT_OA_TAG ]; then
    git checkout ${OPT_OA_TAG}
fi

git describe
git --no-pager log --oneline -5
