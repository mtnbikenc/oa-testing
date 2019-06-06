#!/usr/bin/env bash

CURRENT_USER=$(id -un)
export OPT_CLUSTER_ID=${CURRENT_USER}-${PWD##*-}
export PYTHON=$(which python3 || which python)

##################################################
# Secrets
##################################################
export OPT_PULL_SECRET=~/pull-secret.txt   # https://cloud.openshift.com/clusters/install, Step 4
export OPT_PRIVATE_KEY=${PWD}/../../shared-secrets/aws/libra.pem

##################################################
# Provision/Terminate
##################################################
export OPT_CLUSTER_DIR=${PWD}
export OPT_PLATFORM_TYPE=centos        # rhel/centos
export AWS_PROFILE="openshift-dev"
export AWS_DEFAULT_REGION=us-east-2

#export OPT_REGISTRY=registry.svc.ci.openshift.org/ocp/release
#export OPT_PAYLOAD=4.2                # This points to the latest accepted nightly
#export OPT_PAYLOAD=4.2.0-0.nightly-YYYY-MM-DD-HHMMSS

export OPT_REGISTRY=registry.svc.ci.openshift.org/origin/release
export OPT_PAYLOAD=4.2                # This points to the latest accepted build
#export OPT_PAYLOAD=4.2.0-0.okd-YYYY-MM-DD-HHMMSS

##################################################
# Clone Ansible
##################################################
#export OPT_ANSIBLE_PRNUM=XXXXX
export OPT_ANSIBLE_TAG=v2.8.0
#export OPT_ANSIBLE_TAG=<commit_hash>

##################################################
# Clone OpenShift-Ansible
##################################################
#export OPT_OA_PRNUM=XXXXX
#export OPT_OA_TAG=<branch,commit,tag>
