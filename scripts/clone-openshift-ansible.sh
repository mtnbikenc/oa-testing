#!/usr/bin/env bash
set -ex

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

# Checkout a pull request and rebase it to master
if [ -v OPT_OA_PRNUM ]; then
    git fetch origin pull/${OPT_OA_PRNUM}/head:PR${OPT_OA_PRNUM}
    git checkout PR${OPT_OA_PRNUM}
    git rebase ${OPT_OA_MERGE_BASE}
fi

# Checkout a release branch and update it
#git checkout release-3.7 && git pull --rebase

# Checkout a tag
#git checkout openshift-ansible-3.7.0-0.128.0

# Add a users remote, and checkout a branch
#git remote add mtnbikenc https://github.com/mtnbikenc/openshift-ansible
#export TEST_BRANCH=tests-as-filters
#git fetch mtnbikenc ${TEST_BRANCH}
#git checkout ${TEST_BRANCH}
