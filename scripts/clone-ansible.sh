#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

echo "### Updating git clone of Ansible ###"
unset GIT_DIR
unset GIT_WORK_TREE
if [ ! -d "${OPT_CLUSTER_DIR}/ansible" ]; then
    git clone https://github.com/ansible/ansible.git "${OPT_CLUSTER_DIR}/ansible"
else
    export GIT_DIR=${OPT_CLUSTER_DIR}/ansible/.git
    export GIT_WORK_TREE=${OPT_CLUSTER_DIR}/ansible
    if [ -d "${GIT_DIR}/rebase-apply" ]; then
        rm -rf "${GIT_DIR}/rebase-apply"
    fi
    git reset --hard
    git clean -fdx
    git checkout devel
    git pull --rebase
    git fetch --tags --prune
    git branch | grep -v "devel" | xargs git branch -D || true
fi
export GIT_DIR=${OPT_CLUSTER_DIR}/ansible/.git
export GIT_WORK_TREE=${OPT_CLUSTER_DIR}/ansible

# Checkout a pull request
if [ -v OPT_ANSIBLE_PRNUM ]; then
    git fetch origin "pull/${OPT_ANSIBLE_PRNUM}/merge:PR${OPT_ANSIBLE_PRNUM}"
    git checkout "PR${OPT_ANSIBLE_PRNUM}"
fi

# Checkout a tag
if [ -v OPT_ANSIBLE_TAG ]; then
    git checkout "${OPT_ANSIBLE_TAG}"
fi

git describe
git --no-pager log --oneline -5
