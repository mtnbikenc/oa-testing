#!/usr/bin/env bash
set -ex

./launch.sh
./clone-ansible.sh
./clone-openshift-ansible.sh
./prep.sh
./prereq.sh
./deploy.sh
