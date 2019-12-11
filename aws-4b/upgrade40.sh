#!/usr/bin/env bash
set -euxo pipefail

SCRIPT_TYPE=$(basename -s .sh "$0")
LOG_DATE=$(date "+%FT%H.%M.%S")

mkdir -p logs
unbuffer ../scripts/upgrade40.sh |& tee "logs/${LOG_DATE}-${SCRIPT_TYPE}.log"
