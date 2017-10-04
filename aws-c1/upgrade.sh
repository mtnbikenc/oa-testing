#!/usr/bin/env bash
set -ex

source ansible/hacking/env-setup

source build_options.sh

PLAY_TYPE=$(basename -s .sh "$0")
LOG_DATE=$(date "+%FT%H.%M.%S")
export ANSIBLE_LOG_PATH=${LOG_DATE}-${PLAY_TYPE}-ansible.log

echo "Running upgrade"
time ansible-playbook -i inventory/hosts openshift-ansible/playbooks/byo/openshift-cluster/upgrades/v3_9/upgrade_control_plane.yml -vv
