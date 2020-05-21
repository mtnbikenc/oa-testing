#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

export KUBECONFIG=${OPT_CLUSTER_DIR}/assets/auth/kubeconfig

podman pull "registry.svc.ci.openshift.org/origin/${OPT_PAYLOAD}:tests"
podman run -v "${KUBECONFIG}:/root/.kube/config:z" -i "registry.svc.ci.openshift.org/origin/${OPT_PAYLOAD}:tests" /bin/bash -c 'export KUBECONFIG=/root/.kube/config && openshift-tests run openshift/conformance/parallel'
