#!/bin/bash
set -euxo pipefail

export KUBECONFIG=/root/.kube/config

exec "$@"