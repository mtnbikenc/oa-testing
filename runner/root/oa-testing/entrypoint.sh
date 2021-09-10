#!/bin/bash
set -euxo pipefail

export KUBECONFIG=/oa-testing/cluster/assets/auth/kubeconfig

exec "$@"