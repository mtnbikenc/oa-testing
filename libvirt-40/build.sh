#!/usr/bin/env bash
set -euxo pipefail

clustertype="ipi"
for var in $@; do
  case $var in
    upi)
      clustertype="upi"
      shift
      ;;
  esac
done

./compile-installer.sh
./create-cluster-${clustertype}.sh
#./clone-ansible.sh
#./clone-openshift-ansible.sh
#./node-scaleup40.sh
