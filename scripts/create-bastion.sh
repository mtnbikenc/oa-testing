#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

export KUBECONFIG=${OPT_CLUSTER_DIR}/assets/auth/kubeconfig

echo "Setting up ssh bastion host..."
export SSH_BASTION_NAMESPACE=test-ssh-bastion
curl https://raw.githubusercontent.com/mtnbikenc/ssh-bastion/fix-rolebinding/deploy/deploy.sh | bash
