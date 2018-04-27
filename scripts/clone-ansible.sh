#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

echo "### Updating git clone of Ansible ###"
if [ ! -d ansible ]; then
    git clone https://github.com/ansible/ansible.git
else
    cd ansible
    git reset --hard
    git clean -fdx
    git checkout devel
    git pull --rebase
    cd ..
fi

# Checkout a tag
if [ -v OPT_ANSIBLE_TAG ]; then
    cd ansible
    git checkout ${OPT_ANSIBLE_TAG}
    git submodule update --init --recursive
    cd ..
fi

# Checkout a pull request and rebase it to devel
#export PRNUM=32362
#git fetch origin pull/${PRNUM}/head:PR${PRNUM}
#git checkout PR${PRNUM}
#git rebase devel
