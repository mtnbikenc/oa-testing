#!/usr/bin/env bash

CURRENT_USER=$(whoami)
export OPT_CLUSTER_ID=${CURRENT_USER}-${PWD##*-}

##################################################
# Provision/Terminate
##################################################
export OPT_CLUSTER_DIR=${PWD}
export OPT_MASTER_COUNT=3
export OPT_COMPUTE_COUNT=2
export OPT_INSTANCE_TYPE=t2.medium
#export OPT_INSTANCE_TYPE=c5.large

##################################################
# Clone Ansible
##################################################
#export OPT_ANSIBLE_PRNUM=XXXXX
#export OPT_ANSIBLE_TAG=v2.4.4.0-1
export OPT_ANSIBLE_TAG=v2.6.2
#export OPT_ANSIBLE_TAG=<commit_hash>

##################################################
# Clone OpenShift-Ansible
##################################################
#export OPT_OA_PRNUM=XXXX
#export OPT_OA_TAG=release-3.11
#export OPT_OA_TAG=openshift-ansible-3.9.31-1

##################################################
# Prep
##################################################
#export OPT_PREP_UPGRADE=True
#export OPT_PREP_BUILD_VERSION=v3.9.31-1_2018-06-12.1
#export OPT_PREP_USE_RHN=True
