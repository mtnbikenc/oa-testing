#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

bin/openshift-install destroy cluster --dir=./assets --log-level=debug

find assets/ -type f -not -name '.gitignore' -print0 | xargs -0 -I {} rm -v {}

find bin/ -type f -not -name '.gitignore' -print0 | xargs -0 -I {} rm -v {}

find logs/ -type f -not -name '.gitignore' -print0 | xargs -0 -I {} rm -v {}

rm -fv inventory/hosts
