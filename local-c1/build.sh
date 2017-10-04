#!/usr/bin/env bash
set -e

# echo "Updating version in hosts file..."
# sed -i '/^openshift_release/s/3.3/3.4/g' hosts
# sed -i '/^aos_repo/s/3.3/3.4/g' hosts

echo "Running aws_install_prep.yml"
ansible-playbook -i ./hosts ~/git/aos-ansible/playbooks/aws_install_prep.yml

# echo "Running rhel_subscribe.yml"
# ansible-playbook -i ./hosts rhel_subscribe.yml

# echo "Updating inventory options"
# sed -i '/\[OSEv3:vars\]/ a osm_use_cockpit=false' hosts
# sed -i '/\[OSEv3:vars\]/ a openshift_docker_selinux_enabled=False' hosts
# sed -i '/\[OSEv3:vars\]/ a containerized=true' hosts

echo "Creating a fresh clone of openshift-ansible"
unset GIT_DIR
unset GIT_WORK_TREE
rm -Rf openshift-ansible || true
git clone https://github.com/openshift/openshift-ansible
# export GIT_DIR=${PWD}/openshift-ansible/.git
# export GIT_WORK_TREE=${PWD}/openshift-ansible
# git checkout disable-swap
# git checkout release-1.4
# export PRNUM=3538
# git fetch origin pull/${PRNUM}/head:PR${PRNUM}
# git checkout PR${PRNUM}

echo "Running build"
ansible-playbook -i hosts ./openshift-ansible/playbooks/byo/config.yml -vv
