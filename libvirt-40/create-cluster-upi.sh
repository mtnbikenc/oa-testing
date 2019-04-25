#!/usr/bin/env bash
set -euxo pipefail

source build_options.sh

ansible-playbook -i localhost, create-install-assets.yml

bin/openshift-install create manifests --dir=./assets --log-level=debug

# Modify the apps domain so the cluster can perform lookups internally.
sed -i "/  domain: apps.${OPT_CLUSTER_ID}.tt.testing/c\  domain: apps.tt.testing" assets/manifests/cluster-ingress-02-config.yml

bin/openshift-install create ignition-configs --dir=./assets --log-level=debug
ansible-playbook -i inventory/hosts create-cluster-upi.yml

# Fix permissions so VMs can read the .ign files.
sudo chown qemu:qemu /var/lib/libvirt/images/${OPT_CLUSTER_ID}*

# Start bootstrap and masters
ansible-playbook -i inventory/hosts start-virt-domain.yml --limit bootstrap,masters

# Wait for bootstrap to complete
bin/openshift-install wait-for bootstrap-complete --dir=./assets --log-level=debug

# Destroy the bootstrap host
ansible-playbook -i inventory/hosts stop-virt-domain.yml --limit bootstrap

# Start the workers
ansible-playbook -i inventory/hosts start-virt-domain.yml --limit workers_rhcos

# Wait for install to complete
bin/openshift-install wait-for install-complete --dir=./assets --log-level=debug
