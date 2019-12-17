# OpenShift Ansible Test Cluster Builder

## Overview

## Prerequisites

* ~/.aws/credentials file (Configuring AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html)
* Pull secret saved as ~/pull-secret.txt from https://cloud.openshift.com/clusters/install, Step 4
* OpenShift shared-secrets repo cloned parallel to this repo
* ???

## Fedora Toolbox support
You can run these scripts in Fedora toolbox if you like.

To create the base toolbox image with required packages installed, run:

```bash
$ ../create-toolbox.sh
```

To create a toolbox container for the custer cluster, run:

```bash
$ ./update-toolbox.sh
```

You can then enter the toolbox and run installs as normal.
You can optionally have all the build artifacts redirected to the container
by changing the the OPT_CLUSTER_DIR option in build_options.sh to `/tmp`.
Log files will still be available in the cluster directory.

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