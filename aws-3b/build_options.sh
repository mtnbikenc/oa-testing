#!/usr/bin/env bash

CURRENT_USER=$(id -un)
export OPT_CLUSTER_ID=${CURRENT_USER}-${PWD##*-}
export OPT_LOCAL_DIR=${PWD}

##################################################
# Secrets
##################################################
# pull-secret.txt can be obtained from https://cloud.redhat.com/openshift/install/pull-secret
# You will need to add the CI pull secret to pull from registry.ci.openshift.org
OPT_LOCAL_PULL_SECRET=$(realpath ~/pull-secret.txt)
export OPT_LOCAL_PULL_SECRET
OPT_LOCAL_PRIVATE_KEY=$(realpath "${PWD}/../../shared-secrets/aws/openshift-dev.pem")
export OPT_LOCAL_PRIVATE_KEY

##################################################
# Provision/Terminate
##################################################
export OPT_MASTER_COUNT=3
export OPT_COMPUTE_COUNT=1
export OPT_INFRA_COUNT=2
export OPT_PLATFORM_TYPE=rhel        # rhel/centos/atomic
export OPT_INSTANCE_TYPE=m5.large
export AWS_PROFILE="openshift-dev"
#export AWS_DEFAULT_REGION=us-east-1

##################################################
# Clone OpenShift-Ansible
##################################################
export OPT_OA_BASE_BRANCH=release-3.11
#export OPT_OA_PRNUM=XXXX
export OPT_OA_TAG=release-3.11
#export OPT_OA_TAG=openshift-ansible-3.y.z-1

##################################################
# Prep
##################################################
#export OPT_PREP_BUILD_VERSION=v3.y.z-1_YYYY-MM-DD.1
#export OPT_PREP_USE_RHN=True
