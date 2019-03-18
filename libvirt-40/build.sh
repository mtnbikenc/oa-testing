#!/usr/bin/env bash
set -euxo pipefail

./compile-installer.sh
./create-cluster.sh
#./clone-ansible.sh
#./clone-openshift-ansible.sh
#./node-scaleup40.sh
