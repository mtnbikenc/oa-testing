# OpenShift Ansible Test Cluster Builder

## Overview

This repo will automate the process of building complex OpenShift clusters for
reproducing bugs and testing pull requests.

Basic tasks performed:
* Launch AWS instances
* Clone and checkout a configurable version of Ansible for running playbooks
* Clone and checkout a specific branch/tag/PR of OpenShift-Ansible
* Prepare the AWS instances with proper repo files
* Run the OpenShift-Ansible prerequisites.yml playbook
* Run the OpenShift-Ansible deploy-cluster.yml playbook
* Stop AWS instances and flag for termination, clean up logs

## Prerequisites

* ~/.aws/credentials file (Configuring AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html)
  * A default profile must exist
* Packages: expect (for unbuffer), tee, libselinux-python
* OpenShift shared secrets repo cloned parallel to this repo
* Create ~/openshift-creds.txt with the format below

```
[default]
oreg_auth_password=
rhn_user=
rhn_pass=
rhn_pool=
```

## Building A Cluster

* cd aws-c1
* Update options in build_options.sh as needed
* Update options in inventory/group_vars/OSEv3.yml
* ./build.sh

## Terminating A Cluster

When you are done with a cluster you can run a command to terminate the AWS
instances and clean up logs.

```bash
$ ./terminate.sh
```

## Resetting build options and scripts

If you want to revert all your changes to build options and inventory settings,
you can run a command to revert back to defaults.

```bash
$ ./reset.sh
```
