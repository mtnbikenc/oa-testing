# OpenShift Ansible Test Cluster Builder

## Overview

This repo will automate the process of building complex OpenShift clusters for
reproducing bugs and testing pull requests.

Basic tasks performed:
* Launch AWS instances using aos-launcher
* Clone and checkout a configurable version of Ansible for running playbooks
* Clone and checkout a specific branch/tag/PR of OpenShift-Ansible
* Prepare the AWS instances with proper repo files
* Run the OpenShift-Ansible prerequisites.yml playbook
* Run the OpenShift-Ansible deploy-cluster.yml playbook

## Prerequisites

* aos-launcher cloned parallel to this repo
* ~/.awscreds created (used by aos-launcher)
* Packages: unbuffer, tee
* ???

## Building A Cluster

* cd aws-c1
* Update options in build_options.sh as needed
* Update options in inventory/group_vars/OSEv3.yml
* ./build.sh
