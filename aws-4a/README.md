# OpenShift v4 Test Cluster Builder

## Overview

Basic tasks performed:
* Extract the latest openshift-installer
* Create installer assets
* Run openshift-install create cluster
* Clone and checkout a specific branch/tag/PR of OpenShift-Ansible
* Create an ssh bastion in the cluster for accessing RHEL hosts
* Create machinesets for RHEL instances
* Prepare the RHEL hosts with proper repo files
* Run openshift-ansible playbooks
* Destroy the cluster

## Prerequisites

* Ensure all prerequisites in the project README are met.

## Building and scaling up a cluster

Update options in build_options.sh as needed, then run:

```bash
$ ./test-cluster.sh build
```

## Destroying a cluster

When you are done with a cluster you can run a command to destroy the cluster
and clean up logs.

```bash
$ ./test-cluster.sh destroy
```

## test-cluster.sh Command Help

Running the test-cluster.sh script without any options will print a list of supported commands.

```
$ ./test-cluster.sh
Available commands are:
build                          Build an OpenShift cluster and add worker nodes
extract-installer              Extract openshift-installer from the release image
compile-installer              Compile openshift-installer from source
create-install-assets          Create install assets, i.e. install-config.yaml
create-cluster                 Run openshift-install to create a cluster
clone-openshift-ansible        Clone the OpenShift-Ansible and checks out supplied tag
create-bastion                 Create SSH Bastion Host on the OpenShift cluster
create-machines                Create worker machines on the OpenShift cluster
provision40                    Provision worker machines without using machinesets
prep40                         Prepare repos on worker machines
scaleup                        Run openshift-ansible to scale up worker nodes
drain-coreos                   Drain CoreOS worker nodes
remove-coreos                  Remove CoreOS worker nodes
upgrade                        Run openshift-ansible to upgrade worker nodes
unscaleup                      Remove added worker nodes from cluster
rescaleup                      Run 'create-machines', 'prep40' and 'scaleup'
destroy                        Destroy OpenShift cluster and clean up artifacts
sync-oa                        Sync working openshift-ansible repo with testing repo
e2e-tests                      Run openshift e2e tests
```
