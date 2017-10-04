#!/usr/bin/env bash

CURRENT_USER=$(whoami)

##################################################
# Launcher
##################################################
export OPT_MASTER_COUNT=1
export OPT_NODE_COUNT=1
export OPT_CLUSTER_ID=${CURRENT_USER}-c3
export OPT_INSTANCE_TYPE=t2.medium
#export OPT_INSTANCE_TYPE=c5.large

##################################################
# Clone Ansible
##################################################
#export OPT_ANSIBLE_TAG=v2.4.3.0-1
#export OPT_ANSIBLE_TAG=v2.4.3.0-0.6.rc3

##################################################
# Clone OpenShift-Ansible
##################################################
#export OPT_OA_PRNUM=7000
#export OPT_OA_MERGE_BASE=master
#export OPT_OA_MERGE_BASE=origin/release-3.7
