### vSphere RHEL scale up

### Gotchas
- `ansible.cfg` in openshift-ansible might need to be modified: `control_path = /tmp/%%h-%%r`

### Requirements

- Same as vSphere UPI terraform
- OCP cluster available on vSphere UPI
- RHEL template (see below)

#### RHEL template

The RHEL template must have the following packages
either added or removed
```
yum install open-vm-tools perl -y
# if installed, cloud-init breaks vSphere guest customization
yum erase cloud-init -y
```

### Running terraform

#### Variables

Copy your `terraform.tfvars` to this directory or change
the `terraform apply` for the correct path to the `terraform.tfvars`

This uses most of the exiting variables that vSphere UPI already does.
In the `terraform.rhel.tfvars` modify per your template:

```
rhel_vm_template = "rhel77-template-test"
```

By default the terraform will create three (3) RHEL instances. To change
this add:

```
rhel_compute_count = "#"
```

#### Terraform

Running:

```
terraform init
terraform apply -auto-approve -var-file terraform.tfvars -var-file terraform.rhel.tfvars


#test after complete:
ansible --private-key ~/.ssh/openshift-dev.pem -m setup -i hosts.ini new_workers
```

### Scale Up

Within a `aws-4{a,b}` directory configure `build_options.sh`

Then execute:
```
./test-cluster.sh clone-ansible
./test-cluster.sh clone-openshift-ansible
./test-cluster.sh extract-installer
../scripts/vsphere-scaleup.sh
```

### TODO

- add variables to set netmask and gateway or determine from ipam
- add/modify scripts to integrate with existing scale up
