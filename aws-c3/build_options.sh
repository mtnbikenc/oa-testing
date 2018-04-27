#!/usr/bin/env bash

CURRENT_USER=$(whoami)
export OPT_CLUSTER_ID=${CURRENT_USER}-${PWD#*-}

##################################################
# Launcher
##################################################
export OPT_MASTER_COUNT=1
export OPT_NODE_COUNT=1
export OPT_INSTANCE_TYPE=t2.medium
#export OPT_INSTANCE_TYPE=c5.large

##################################################
# Clone Ansible
##################################################
export OPT_ANSIBLE_TAG=v2.4.3.0-1
#export OPT_ANSIBLE_TAG=v2.5.0

##################################################
# Clone OpenShift-Ansible
##################################################
#export OPT_OA_PRNUM=7000
#export OPT_OA_TAG=release-3.7
#export OPT_OA_TAG=openshift-ansible-3.9.0-0.36.0

##################################################
# Prep
##################################################
#export OPT_OA_UPGRADE=True
#export OPT_BUILD_VERSION=v3.7.22-1_2018-01-08.4
