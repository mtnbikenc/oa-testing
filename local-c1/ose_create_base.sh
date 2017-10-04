#!/bin/bash
VMPATH=/var/lib/libvirt/images
ISOPATH=$VMPATH/rhel-server-7.3-x86_64-dvd.iso

#create a thin provisioned QCOW2 image file for the base image
qemu-img create -f qcow2 $VMPATH/base-el73.qcow2 30G

#create the virtual machine to use as the base
virt-install -v --name base-el73 \
--memory 2048 \
--disk bus=virtio,path=$VMPATH/base-el73.qcow2 \
-w network=openshift,model=virtio,mac=52:54:00:b3:3d:1c \
--noautoconsole \
-l $ISOPATH
