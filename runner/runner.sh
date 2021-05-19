#!/usr/bin/env bash
set -euxo pipefail

mkdir --parents "${OPT_LOCAL_DIR}/assets/auth/"
touch "${OPT_LOCAL_DIR}/assets/auth/kubeconfig"

# Workaround Ansible 2.9 limitation of cross device linking for templated files
# by mounting a local directory to the default Ansible tmp directory
mkdir --parents "/tmp/oa-testing-runner"

#podman run --rm --interactive --tty \
podman run --rm \
  --env OPT_* \
  --env AWS_* \
  --env ANSIBLE_* \
  --volume "${HOME}/openshift-creds.txt:/oa-testing/openshift-creds.txt:z" \
  --volume "${HOME}/.aws:/root/.aws:z" \
  --volume "${OPT_LOCAL_DIR}/assets/auth/kubeconfig:/root/.kube/config:z" \
  --volume "${OPT_LOCAL_PRIVATE_KEY}:/oa-testing/openshift-dev.pem:z" \
  --volume "${OPT_LOCAL_OPS_MIRROR_KEY}:/oa-testing/ops-mirror.pem:z" \
  --volume "${OPT_LOCAL_PULL_SECRET}:/oa-testing/pull-secret.txt:z" \
  --volume "${OPT_LOCAL_DIR}:/oa-testing/cluster:z" \
  --volume "${OPT_LOCAL_DIR}/../playbooks:/oa-testing/playbooks:z" \
  --volume "${OPT_LOCAL_DIR}/../scripts:/oa-testing/scripts:z" \
  --volume "/tmp/oa-testing-runner:/root/.ansible:z" \
  --workdir "/oa-testing/cluster" \
  localhost/oa-runner-base \
  "$@"
#  /bin/bash
