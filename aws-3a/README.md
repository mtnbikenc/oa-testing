# OpenShift v4 Test Cluster Builder

## Overview

Basic tasks performed:
* Clone and checkout a specific branch/tag/PR of OpenShift-Ansible
* Launch AWS instances
* Prepare the AWS instances with proper repo files
* Run openshift-ansible playbooks
* Terminate AWS resources

## Building a cluster

* Update options in build_options.sh as needed
* Update options in inventory/group_vars/OSEv3.yml
* ./test-cluster.sh build

## Terminating a cluster

When you are done with a cluster you can run a command to terminate the AWS
instances and clean up logs.

```bash
$ ./test-cluster.sh terminate
```

## test-cluster.sh Command Help

Running the test-cluster.sh script without any options will print a list of supported commands.

```
$ ./test-cluster.sh
Available commands are:
build                          Build an OpenShift cluster
clone-openshift-ansible        Clone the openshift-ansible repo
provision-vpc                  Provision a AWS VPC for cluster deployment
provision                      Provision AWS instances for cluster deployment
prep                           Prepare repos on instances
prereq                         Run prerequisites playbook
deploy                         Run deploy_cluster playbook
get-kubeconfig                 Obtain the kubeconfig from the cluster
upgrade                        Run cluster upgrade playbook
upgrade-control-plane          Run control plane upgrade playbook
upgrade-nodes                  Run nodes upgrade playbook
master-config                  Run master config playbook
openshift-node-group           Run openshift node group playbook
master-scaleup                 Run master scaleup playbook
etcd-scaleup                   Run etcd scaleup playbook
node-scaleup                   Run node scaleup playbook
master-components              Run master components config playbook
monitoring-config              Run monitoring config playbook
metering-config                Run metering config playbook
web-console-config             Run web-console config playbook
console-config                 Run console config playbook
metrics-config                 Run metrics config playbook
metrics-server-config          Run metrics server config playbook
logging-config                 Run logging config playbook
monitor-availability-config    Run monitor-availability config playbook
service-catalog-config         Run service-catalog config playbook
olm-config                     Run olm config playbook
descheduler-config             Run descheduler config playbook
node-problem-detector-config   Run node-problem-detector config playbook
autoheal-config                Run autoheal config playbook
cluster-autoscaler-config      Run cluster-autoscaler config playbook
cert-check                     Run certificate expiry easy-mode playbook
redeploy-cert                  Run certificate redeploy playbook
redeploy-master-cert           Run master certificate redeploy playbook
redeploy-openshift-ca          Run OpenShift CA redeploy playbook
redeploy-service-catalog-cert  Run service catalog certificate redeploy playbook
redeploy-router-cert           Run hosted router certificate redeploy playbook
redeploy-registry-cert         Run hosted registry certificate redeploy playbook
node-restart                   Run node restart playbook
terminate                      Terminate cluster instances & VPC
terminate-instances            Terminate cluster instances
terminate-vpc                  Terminate cluster VPC
sync-oa                        Sync working openshift-ansible repo with testing repo
ssh                            ssh to a cluster node
```
