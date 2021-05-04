#!/usr/bin/env bash
set -euxo pipefail

echo "Setting up ssh bastion host..."
export SSH_BASTION_NAMESPACE=test-ssh-bastion
curl https://raw.githubusercontent.com/eparis/ssh-bastion/master/deploy/deploy.sh | bash -x
