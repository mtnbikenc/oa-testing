#!/usr/bin/env bash

export GIT_DIR=~/git/openshift-ansible/.git
export GIT_WORK_TREE=~/git/openshift-ansible

for i in $(seq 10 -1 1); do
    YESTERDAY=$(date -I --date "now - ${i} day")
    TODAY=$(date -I --date "now - $[i-1] day")

    MERGES=$(git log --merges --after="${YESTERDAY} 00:00" --before="${TODAY} 00:00" --format="%cd %an")
    MERGES_ALL=$(wc -l <<< "${MERGES}")
    MERGES_BOT=$(grep 'Merge Robot' <<< "${MERGES}" | wc -l)
    MERGES_OTHERS=$(grep -v 'Merge Robot' <<< "${MERGES}" | wc -l)
    echo ${YESTERDAY} ${MERGES_ALL} ${MERGES_BOT} ${MERGES_OTHERS}

done
