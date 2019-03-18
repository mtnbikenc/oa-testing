#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

ansible-playbook -i localhost, create-install-assets.yml

bin/openshift-install create manifests --dir=./assets --log-level=debug

# Modify the apps domain so the cluster can perform lookups internally.
sed -i "/  domain: apps.${OPT_CLUSTER_ID}.tt.testing/c\  domain: apps.tt.testing" assets/manifests/cluster-ingress-02-config.yml

bin/openshift-install create cluster --dir=./assets --log-level=debug
