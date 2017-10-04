#!/usr/bin/env bash
set -e

VMPATH=/var/lib/libvirt/images
OSE_NODES="ose3-master ose3-node1 ose3-node2"

echo "Unregister Systems"
for vm in $OSE_NODES; do ssh $vm.example.com subscription-manager remove --all; done

echo "Stopping OpenShift VMs"
for vm in $OSE_NODES; do sudo virsh destroy $vm; done

echo "Removing QCOW2 Snapshots"
for vm in $OSE_NODES; do sudo rm -f $VMPATH/$vm.qcow2; done

echo "Creating new QCOW2 snapshots"
for vm in $OSE_NODES; do sudo qemu-img create -f qcow2 -b $VMPATH/base-el73.qcow2 $VMPATH/$vm.qcow2; done

echo "Removing ansible.log"
rm ansible.log

echo "Deleting openshift-ansible repo"
rm -Rf openshift-ansible
