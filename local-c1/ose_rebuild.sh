#!/bin/bash

VMPATH=/var/lib/libvirt/images

# destroy VMs
echo Stopping OpenShift VMs......
/bin/virsh destroy ose3-master
/bin/virsh destroy ose3-node1
/bin/virsh destroy ose3-node2

#remove snapshot QCOWs
echo -n "Are you sure you want to reset your OSE v3 environment? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo Here goes nothin\'
else
    echo Second thoughts eh? Better luck next time. ;exit
fi
echo Removing QCOW2 Snapshots.......
for vm in ose3-master ose3-node1 ose3-node2; do rm -f $VMPATH/$vm.qcow2; done


#create new snapshots
echo creating new QCOW2 snapshots
for vm in ose3-master ose3-node1 ose3-node2; do qemu-img create -f qcow2 -b $VMPATH/base-el73.qcow2 $VMPATH/$vm.qcow2; done


#start VMs
echo Wow see how easy that was? \n\n
echo -n "Would you like to start the VMs now? (y/n)"
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo Starting VMs ; /bin/virsh start ose3-master; /bin/virsh start ose3-node1; /bin/virsh start ose3-node2
else
    echo Fine then. Your OSE v3 env is waiting quietly and will be ready when you are. ;exit
fi
