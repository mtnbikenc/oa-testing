#!/usr/bin/env bash
set -euxo pipefail

./extract-installer.sh
./create-install-assets.sh
./create-cluster.sh
./clone-ansible.sh
./clone-openshift-ansible.sh
./create-bastion.sh
./create-machines.sh
./prep40.sh
./node-scaleup40.sh
