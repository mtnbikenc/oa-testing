#!/usr/bin/env bash
set -euxo pipefail

echo "### Updating git clone of openshift-ansible ###"
unset GIT_DIR
unset GIT_WORK_TREE
if [ ! -d "/oa-testing/cluster/openshift-ansible" ]; then
    git clone https://github.com/openshift/openshift-ansible "/oa-testing/cluster/openshift-ansible"
else
    export GIT_DIR="/oa-testing/cluster/openshift-ansible/.git"
    export GIT_WORK_TREE="/oa-testing/cluster/openshift-ansible"
    if [ -d "${GIT_DIR}/rebase-apply" ]; then
        rm -rf "${GIT_DIR}/rebase-apply"
    fi
    git reset --hard
    git clean -fdx
    git checkout master
    git pull --rebase
    git fetch --tags --prune
    git branch | grep -v "master" | xargs git branch -D || true
fi
export GIT_DIR="/oa-testing/cluster/openshift-ansible/.git"
export GIT_WORK_TREE="/oa-testing/cluster/openshift-ansible"

# Checkout a pull request
if [ -v OPT_OA_PRNUM ]; then
  if [ -v OPT_OA_BASE_BRANCH ]; then
    git checkout "${OPT_OA_BASE_BRANCH}"
  fi
  git checkout -b temp-merge

  for PRNUM in ${OPT_OA_PRNUM}
  do
    git fetch origin "pull/${PRNUM}/head:PR${PRNUM}"
    git merge "PR${PRNUM}" -m "Merging ${PRNUM}"
  done
fi

# Checkout a tag
if [ -v OPT_OA_TAG ]; then
    git checkout "${OPT_OA_TAG}"
fi

git describe
git --no-pager log --oneline -5
