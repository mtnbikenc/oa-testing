#!/usr/bin/env bash
set -euxo pipefail
source build_options.sh
# shellcheck source=/dev/null
source "${OPT_CLUSTER_DIR}/ansible/hacking/env-setup"

export ANSIBLE_STDOUT_CALLBACK=yaml
time ${LOCAL_PYTHON} "$(command -v ansible-playbook)" -i "../terraform/vsphere/hosts.ini" ../playbooks/prep40.yml -vv

pushd "${OPT_CLUSTER_DIR}/openshift-ansible"
# Use the extracted `oc` when running playbooks
PATH=${OPT_CLUSTER_DIR}/bin:$PATH
command -v oc

time ${LOCAL_PYTHON} "$(command -v ansible-playbook)" -i "../../terraform/vsphere/hosts.ini" playbooks/scaleup.yml -vv

popd
