#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

#export TF_LOG=debug  # Enable this for terraform debugging
"${OPT_CLUSTER_DIR}/bin/openshift-install" create cluster --dir="${OPT_CLUSTER_DIR}/assets" --log-level=debug
