#!/usr/bin/env bash
set -euxo pipefail

# Retrieve CI vars file from release repo
curl -o openshift-ansible/inventory/dynamic/aws/group_vars/all/vars.yaml https://raw.githubusercontent.com/openshift/release/master/cluster/test-deploy/aws-4.0/vars.yaml
# Switch AMI for scaleup to public CentOS image in us-east-2
sed -i 's/^openshift_aws_scaleup_ami.*/openshift_aws_scaleup_ami: "ami-0f2b4fc905b0bd1f1"  #us-east-2/' openshift-ansible/inventory/dynamic/aws/group_vars/all/vars.yaml
# Update username for public CentOS image
sed -i 's/ec2-user/centos/g' openshift-ansible/inventory/dynamic/aws/group_vars/all/vars.yaml
# Copy libra.pem file to dynamic injected inventory
cp $(pwd)/../../shared-secrets/aws/libra.pem openshift-ansible/inventory/dynamic/injected/ssh-privatekey
# Copy ops-mirror.pem file to dynamic injected inventory
cp $(pwd)/../../shared-secrets/mirror/ops-mirror.pem openshift-ansible/inventory/dynamic/injected
# Create host_vars directory for localhost vars file
mkdir -p openshift-ansible/inventory/dynamic/aws/host_vars
# Create localhost vars file to disable ansible_become
cat > openshift-ansible/inventory/dynamic/aws/host_vars/localhost.yml <<EOF
---
ansible_become: false
EOF

# Run the scaleup
SCRIPT_TYPE=$(basename -s .sh "$0")
LOG_DATE=$(date "+%FT%H.%M.%S")

export ANSIBLE_CONFIG=${PWD}/openshift-ansible/inventory/dynamic/aws/ansible.cfg

unbuffer ../scripts/node-scaleup40.sh |& tee logs/${LOG_DATE}-${SCRIPT_TYPE}.log
