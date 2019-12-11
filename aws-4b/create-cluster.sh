#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

"${OPT_CLUSTER_DIR}/bin/openshift-install" create cluster --dir="${OPT_CLUSTER_DIR}/assets" --log-level=debug
