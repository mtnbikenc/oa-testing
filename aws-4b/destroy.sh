#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

if [ -f "${OPT_CLUSTER_DIR}/assets/metadata.json" ]
then
  "${OPT_CLUSTER_DIR}/bin/openshift-install" destroy cluster --dir="${OPT_CLUSTER_DIR}/assets" --log-level=debug
fi

rm -rfv "${OPT_CLUSTER_DIR}/assets/"

rm -rfv "${OPT_CLUSTER_DIR:?}/bin/"

rm -rfv "${OPT_CLUSTER_DIR}/inventory/"

rm -rfv "logs/"
