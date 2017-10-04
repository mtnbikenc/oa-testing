#!/bin/bash
VMPATH=/var/lib/libvirt/images

for vm in ose3-master ose3-node1 ose3-node2; do qemu-img create -f qcow2 -b $VMPATH/base-el73.qcow2 $VMPATH/$vm.qcow2; done
