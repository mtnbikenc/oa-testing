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
OPT_LOCAL_OPS_MIRROR_KEY="${PWD}/../../shared-secrets/mirror/ops-mirror.pem"
export OPT_LOCAL_OPS_MIRROR_KEY

##################################################
# Provision/Terminate
##################################################
export OPT_PLATFORM_TYPE=rhel         # rhel/centos
export OPT_PLATFORM_VERSION=7.9
export OPT_INSTANCE_TYPE=m4.large
export AWS_PROFILE="openshift-dev"
export AWS_DEFAULT_REGION=us-east-2

#export OPT_REGISTRY=registry.ci.openshift.org/origin/release
export OPT_REGISTRY=registry.ci.openshift.org/ocp/release
export OPT_PAYLOAD=4.8                # This points to the latest accepted nightly build
#export OPT_PAYLOAD=4.x-ci             # This points to the latest accepted CI build
#export OPT_PAYLOAD=4.x.0-0.nightly-YYYY-MM-DD-HHMMSS

#export OPT_REGISTRY=quay.io/openshift-release-dev/ocp-release
#export OPT_PAYLOAD=4.x.x-x86_64

export OPT_RELEASE_IMAGE="${OPT_REGISTRY}":"${OPT_PAYLOAD}"
#export OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE="${OPT_RELEASE_IMAGE}"

##################################################
# Clone OpenShift-Ansible
##################################################
#export OPT_OA_PRNUM=XXXXX
#export OPT_OA_TAG=<branch,commit,tag>
