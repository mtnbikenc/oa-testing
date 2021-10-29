# OpenShift Ansible Test Cluster Builder

## Overview

This repo will automate the process of building complex OpenShift clusters for
reproducing bugs and testing pull requests.

## Prerequisites

* Install packages: `buildah podman`

* Create ~/.aws/credentials file
  * Configuring AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html
```
[openshift-dev]
aws_access_key_id = XXXXX
aws_secret_access_key = xxxxx
```

* Create ~/.aws/config and define a default region
```
[profile openshift-dev]
region = us-east-2
```

* Create ~/openshift-creds.txt with the format below
  * Copy the token from the 'oc login' line at https://console.reg-aws.openshift.com/console/command-line
  * Put the token on the `oreg_auth_password` line below
```
[default]
oreg_auth_password = xxxxx
rhn_user = user@email.com
rhn_pass = xxxxx
rhn_pool = xxxxx
mirror_username = xxxxx
mirror_password = xxxxx
```

NOTE: mirror.openshift.com is migrating to a new infrastructure that requires
authentication.  Request an automation username/password from the ART Team for
mirror_username and mirror_password. See https://issues.redhat.com/browse/ART-3018

* Create ~/pull-secret.txt
  * pull-secret.txt can be obtained from https://cloud.redhat.com/openshift/install/pull-secret
  * Add your CI pull secret to pull from registry.ci.openshift.org
    (https://console-openshift-console.apps.ci.l2s4.p1.openshiftapps.com/)
  * Add your quay.io pull secret

## Building the containerized playbook runner image

All the tasks to build clusters is run from within a container with all the required dependencies.
The runner.sh script will mount needed secrets created during Prerequisites above.
Execute the commands below to build the container image, `oa-runner-base`.

```bash
$ cd runner
$ ./build-runner.sh
```

## Building clusters

Four pre-built directories are provided for building v3 or v4 OpenShift clusters.
`aws-3a` and `aws-3b` are used for creating OpenShift v3 clusters in AWS.
`aws-4a` and `aws-4b` are used for creating OpenShift v4 clusters in AWS.
Once the `oa-runner-base` image is built, clusters can be built by following the README in these directories.

Cluster resources will be created using the combination of the current username and the part of the working
directory name following the dash (`-`).  For example, `myusername-4a` when using `aws-4a`.

Each directory has a `build_options.sh` file which can be used to configure things like versions to install or
operating systems to use.

The ./test-cluster.sh `build` command runs an ordered list of commands to build a complete cluster.
Each of these commands can be run separately or multiple commands can be run at once.

```commandline
$ ./testcluster.sh build
$ ./testcluster.sh provision-vpc provision prep
$ ./testcluster.sh build remove-coreos upgrade e2e-tests
```

The output for each command is logged in the `logs/` directory.