# OpenShift Ansible Test Cluster Builder

## Overview

## Prerequisites

* libvirt installed and configured per https://github.com/openshift/installer/blob/master/docs/dev/libvirt-howto.md
* Pull secret saved as ~/pull-secret.txt from https://cloud.openshift.com/clusters/install, Step 4
* OpenShift shared-secrets repo cloned parallel to this repo
* ???

## Add dns to libvirt

Add the following lines to your libvirt dnsmasq and restart NetworkManager

```bash
echo server=/tt.testing/192.168.126.1 | sudo tee /etc/NetworkManager/dnsmasq.d/openshift.conf
echo address=/.apps.tt.testing/192.168.126.51 | sudo tee -a /etc/NetworkManager/dnsmasq.d/openshift.conf
sudo systemctl reload NetworkManager
```

## rhcos image (Required for UPI only)

UPI clusters need an rhcos image. To get it, first install an IPI
cluster (below) to cache the image to your ~/.cache. Next create a
symlink here

```bash
$ ln -s -f ~/.cache/openshift-install/libvirt/image/$(ls -tr ~/.cache/openshift-install/libvirt/image/ | tail -n 1) rhcos.qcow2
```

## Create an ansible inventory file

UPI and scaleup rely on an inventory.

```bash
cp inventory/hosts.example inventory/hosts
sed -i "s/user-40/${USER}-40/g" inventory/hosts
```

## Building and scaling up a cluster

Update options in build_options.sh as needed, then run:

```bash
$ ./build.sh
```

Or, you can build a upi cluster by running:

```bash
$ ./build.sh upi
```

## Monitoring Progress

```bash
$ source build_options.sh
$ watch 'oc get nodes && oc get csr && oc get clusteroperators'
```

## UPI 100% complete, waiting on image-registry

The image-registry does not have storage configured when using UPI and will not
deploy. Use the following to setup emptyDir storage for the image-registry.

```bash
$ source build_options.sh
$ oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"storage":{"emptyDir":{}}}}'
```

## Destroying a cluster

When you are done with a cluster you can run a command to destroy the cluster
and clean up logs. This will also destroy all libvirt domains, volumes, and
networks that begin with ${OPT_CLUSTER_ID} as configured in build_options.sh

```bash
$ ./destroy.sh
```
