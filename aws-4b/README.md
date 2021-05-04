# OpenShift Ansible Test Cluster Builder

## Overview

## Prerequisites

* ~/.aws/credentials file (Configuring AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html)
* Pull secret saved as ~/pull-secret.txt from https://cloud.openshift.com/clusters/install, Step 4
* OpenShift shared-secrets repo cloned parallel to this repo
* ???

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

## test-cluster.sh Script
Running `./test-cluster.sh` without any options will print a list of available commands.