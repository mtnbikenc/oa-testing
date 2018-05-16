#!/usr/bin/env bash
set -euxo pipefail

./launch.sh
./clone-ansible.sh
./clone-openshift-ansible.sh
./prep.sh
./prereq.sh
./deploy.sh
