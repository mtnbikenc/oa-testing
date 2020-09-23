#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

time ansible-playbook -i localhost, ../playbooks/terminate.yml -vvv -e "ansible_python_interpreter=${PYTHON}"

if [ -f "${OPT_CLUSTER_DIR}/inventory/aws_vpc.json" ]
then
  aws cloudformation delete-stack --stack-name "${OPT_CLUSTER_ID}"
  aws cloudformation wait stack-delete-complete --stack-name "${OPT_CLUSTER_ID}"
  rm -rfv "${OPT_CLUSTER_DIR}/inventory/aws_vpc.json"
fi

rm -rfv ansible.log
rm -rfv "${OPT_CLUSTER_DIR}/assets/"
rm -rfv "logs/"
