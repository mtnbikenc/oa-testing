#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

echo "### Updating clone of openshift-ansible ###"
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
    git branch | grep -v "master" | xargs git branch -D || true
fi
export GIT_DIR=${PWD}/openshift-ansible/.git
export GIT_WORK_TREE=${PWD}/openshift-ansible

# Checkout a pull request and rebase it to origin
if [ -v OPT_OA_PRNUM ]; then
    git fetch origin pull/${OPT_OA_PRNUM}/merge:PR${OPT_OA_PRNUM}
    git checkout PR${OPT_OA_PRNUM}
    git describe
    git log --oneline -5
fi

# Checkout a tag
if [ -v OPT_OA_TAG ]; then
    git checkout ${OPT_OA_TAG}
fi

# Checkout a release branch and update it
#git checkout release-3.7 && git pull --rebase

# Add a users remote, and checkout a branch
#git remote add mtnbikenc https://github.com/mtnbikenc/openshift-ansible
#export TEST_BRANCH=tests-as-filters
#git fetch mtnbikenc ${TEST_BRANCH}
#git checkout ${TEST_BRANCH}
