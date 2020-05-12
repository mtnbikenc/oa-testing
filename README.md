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

* cd aws-3a
* Update options in build_options.sh as needed
* Update options in inventory/group_vars/OSEv3.yml
* ./test-cluster.sh build

## Terminating A Cluster

When you are done with a cluster you can run a command to terminate the AWS
instances and clean up logs.

```bash
$ ./test-cluster.sh terminate
```

## test-cluster.sh Command Help

Running the test-cluster.sh script without any options will print a list of supported commands.

```bash
$ ./test-cluster.sh
Available commands are:
build                          Build an OpenShift cluster
provision                      Provision instances for cluster deployment
clone-ansible                  Clone the Ansible repo and checks out supplied tag
clone-openshift-ansible        Clone the OpenShift-Ansible and checks out supplied tag
prep                           Prepare repos on instances
prereq                         Run prerequisites playbook
deploy                         Run deploy_cluster playbook
upgrade                        Run cluster upgrade playbook
master-scaleup                 Run master scaleup playbook
etcd-scaleup                   Run etcd scaleup playbook
node-scaleup                   Run node scaleup playbook
logging-config                 Run logging config playbook
terminate                      Terminate cluster instances
sync-oa                        Sync working openshift-ansible repo with testing repo
cert-check                     Run certificate expiry easy-mode playbook
redeploy-cert                  Run certificate redeploy playbook
redeploy-ca                    Run OpenShift CA redeploy playbook
```