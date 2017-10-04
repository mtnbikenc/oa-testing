#!/bin/bash
VMPATH=/var/lib/libvirt/images

virt-install -v --name ose3-master --ram 2048 --disk bus=virtio,path=$VMPATH/ose3-master.qcow2 -w network=openshift,model=virtio,mac=52:54:00:b3:3d:1d --noautoconsole --boot hd
virt-install -v --name ose3-node1  --ram 2048 --disk bus=virtio,path=$VMPATH/ose3-node1.qcow2  -w network=openshift,model=virtio,mac=52:54:00:b3:3d:1e --noautoconsole --boot hd
virt-install -v --name ose3-node2  --ram 2048 --disk bus=virtio,path=$VMPATH/ose3-node2.qcow2  -w network=openshift,model=virtio,mac=52:54:00:b3:3d:1f --noautoconsole --boot hd
