#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

bin/openshift-install destroy cluster --dir=./assets --log-level=debug || true

for domain in $(virsh --connect=qemu:///system list --name --all | grep "^${OPT_CLUSTER_ID}-"); do
  virsh --connect=qemu:///system destroy ${domain} || true
  virsh --connect=qemu:///system undefine ${domain}
done

for volume in $(virsh --connect=qemu:///system vol-list default | cut -d " " -f2 | grep "^${OPT_CLUSTER_ID}-"); do
  virsh --connect=qemu:///system vol-delete --pool=default ${volume}
done

virsh --connect=qemu:///system net-destroy ${OPT_CLUSTER_ID} || true
virsh --connect=qemu:///system net-undefine ${OPT_CLUSTER_ID} || true

rm -rf ./assets/*
rm -f ./assets/.openshift_install*

rm -f extra_vars.yml

rm -f logs/*.log
