#!/usr/bin/env bash
set -ex

echo "### Updating git clone of Ansible ###"
unset GIT_DIR
unset GIT_WORK_TREE
if [ ! -d ansible ]; then
    git clone https://github.com/ansible/ansible.git
else
    export GIT_DIR=${PWD}/ansible/.git
    export GIT_WORK_TREE=${PWD}/ansible
    git reset --hard
    git clean -fdx
    git checkout devel
    git pull --rebase
fi
export GIT_DIR=${PWD}/ansible/.git
export GIT_WORK_TREE=${PWD}/ansible

# Checkout a tag
if [ -v OPT_ANSIBLE_TAG ]; then
    git checkout ${OPT_ANSIBLE_TAG}
fi

# Checkout a pull request and rebase it to devel
#export PRNUM=32362
#git fetch origin pull/${PRNUM}/head:PR${PRNUM}
#git checkout PR${PRNUM}
#git rebase devel
