#!/usr/bin/env bash
set -euxo pipefail

toolbox rm --force oa-testing-aws-4a
toolbox create --image oa-testing-base --container oa-testing-aws-4a