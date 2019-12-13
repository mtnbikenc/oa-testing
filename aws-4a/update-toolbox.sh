#!/usr/bin/env bash
set -euxo pipefail

toolbox rm --force "oa-testing-${PWD##*/}" || true
toolbox create --image oa-testing-base --container "oa-testing-${PWD##*/}"