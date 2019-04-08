#!/usr/bin/env bash

CURRENT_USER=$(id -un)
export OPT_CLUSTER_ID=${CURRENT_USER}-${PWD##*-}
export PYTHON=$(which python2)

##################################################
# Provision/Terminate
##################################################
export OPT_CLUSTER_DIR=${PWD}
export OPT_MASTER_COUNT=3
export OPT_COMPUTE_COUNT=1
export OPT_INFRA_COUNT=2
export OPT_PLATFORM_TYPE=rhel        # rhel/centos
export OPT_INSTANCE_TYPE=t2.medium
#export OPT_INSTANCE_TYPE=c5.large

##################################################
# Clone Ansible
##################################################
#export OPT_ANSIBLE_PRNUM=XXXXX
#export OPT_ANSIBLE_TAG=v2.7.5
export OPT_ANSIBLE_TAG=v2.4.3.0-1
#export OPT_ANSIBLE_TAG=<commit_hash>

##################################################
# Clone OpenShift-Ansible
##################################################
#export OPT_OA_PRNUM=XXXX
export OPT_OA_TAG=release-3.10
#export OPT_OA_TAG=openshift-ansible-3.10.72-1

##################################################
# Prep
##################################################
#export OPT_PREP_UPGRADE=True
#export OPT_PREP_BUILD_VERSION=v3.10.72-1_2018-11-10.1
#export OPT_PREP_USE_RHN=True
#export OPT_OPS_MIRROR_PATH=/projects/shared-secrets/mirror/ops-mirror.pem
