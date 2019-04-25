#!/usr/bin/env bash

CURRENT_USER=$(id -un)
export OPT_CLUSTER_ID=${CURRENT_USER}-${PWD##*-}
export PYTHON=$(which python3)
export KUBECONFIG=${PWD}/assets/auth/kubeconfig

##################################################
# Secrets
##################################################
export OPT_PULL_SECRET=~/pull-secret.txt   # https://cloud.openshift.com/clusters/install, Step 4
export OPT_PRIVATE_KEY=${PWD}/../../shared-secrets/aws/libra.pem

##################################################
# Provision/Terminate
##################################################
export OPT_CLUSTER_DIR=${PWD}
export OPT_MASTER_COUNT=0
export OPT_COMPUTE_COUNT=1
export OPT_INFRA_COUNT=0
export OPT_PLATFORM_TYPE=centos        # rhel/centos
export OPT_INSTANCE_TYPE=t2.medium
#export OPT_INSTANCE_TYPE=c5.large
export AWS_PROFILE="openshift-dev"
export AWS_DEFAULT_REGION=us-east-2

##################################################
# Clone Ansible
##################################################
#export OPT_ANSIBLE_PRNUM=XXXXX
export OPT_ANSIBLE_TAG=v2.7.8
#export OPT_ANSIBLE_TAG=<commit_hash>

##################################################
# Clone OpenShift-Ansible
##################################################
#export OPT_OA_PRNUM=XXXXX
export OPT_OA_TAG=devel-40
