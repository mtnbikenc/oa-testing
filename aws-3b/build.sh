#!/usr/bin/env bash
set -euxo pipefail

./provision.sh
./clone-ansible.sh
./clone-openshift-ansible.sh
./prep.sh
./prereq.sh
./deploy.sh
