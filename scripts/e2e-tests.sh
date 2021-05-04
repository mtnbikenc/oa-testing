#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

export KUBECONFIG=${OPT_LOCAL_DIR}/assets/auth/kubeconfig

podman pull "registry.ci.openshift.org/origin/${OPT_PAYLOAD}:tests"
podman run --rm --interactive \
  --volume "${KUBECONFIG}:/root/.kube/config:z" \
  "registry.ci.openshift.org/origin/${OPT_PAYLOAD}:tests" \
  /bin/bash -c 'export KUBECONFIG=/root/.kube/config && openshift-tests run openshift/conformance/parallel'

# Specify tests file
#podman run --rm --interactive \
#  --volume "${KUBECONFIG}:/root/.kube/config:z" \
#  --volume "${PWD}/tests.txt:/tmp/tests.txt:z" \
#  "registry.ci.openshift.org/origin/${OPT_PAYLOAD}:tests" \
#  /bin/bash -c 'export KUBECONFIG=/root/.kube/config && openshift-tests run -f /tmp/tests.txt'
