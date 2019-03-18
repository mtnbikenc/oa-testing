# OpenShift Ansible Test Cluster Builder

## Overview

## Prerequisites

* libvirt installed and configured per https://github.com/openshift/installer/blob/master/docs/dev/libvirt-howto.md
* Pull secret saved as ~/pull-secret.txt from https://cloud.openshift.com/clusters/install, Step 4
* OpenShift shared-secrets repo cloned parallel to this repo
* ???

## Add dns to libvirt

Add the following lines to your libvirt dnsmasq:

```bash
echo server=/tt.testing/192.168.126.1 | sudo tee /etc/NetworkManager/dnsmasq.d/openshift.conf
echo address=/.apps.tt.testing/192.168.126.51 | sudo tee -a /etc/NetworkManager/dnsmasq.d/openshift.conf
sudo systemctl reload NetworkManager
```

## Building and scaling up a cluster

Update options in build_options.sh as needed, then run:

```bash
$ ./build.sh
```

## Destroying a cluster

When you are done with a cluster you can run a command to destroy the cluster
and clean up logs.

```bash
$ ./destroy.sh
```
