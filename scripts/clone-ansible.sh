#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

echo "### Updating git clone of Ansible ###"
unset GIT_DIR
unset GIT_WORK_TREE
if [ ! -d ansible ]; then
    git clone https://github.com/ansible/ansible.git
else
    export GIT_DIR=${PWD}/ansible/.git
    export GIT_WORK_TREE=${PWD}/ansible
    if [ -d ${GIT_DIR}/rebase-apply ]; then
        rm -rf ${GIT_DIR}/rebase-apply
    fi
    git reset --hard
    git clean -fdx
    git checkout devel
    git pull --rebase
    git fetch --tags --prune
    git branch | grep -v "devel" | xargs git branch -D || true
fi
export GIT_DIR=${PWD}/ansible/.git
export GIT_WORK_TREE=${PWD}/ansible

# Checkout a pull request
if [ -v OPT_ANSIBLE_PRNUM ]; then
    git fetch origin pull/${OPT_ANSIBLE_PRNUM}/merge:PR${OPT_ANSIBLE_PRNUM}
    git checkout PR${OPT_ANSIBLE_PRNUM}
fi

# Checkout a tag
if [ -v OPT_ANSIBLE_TAG ]; then
    git checkout ${OPT_ANSIBLE_TAG}
fi

git describe
git log --oneline -5
