#!/usr/bin/env bash
set -o errtrace -o errexit -o nounset -o pipefail

function build {  ## Build an OpenShift cluster
  clone-openshift-ansible
  provision-vpc
  provision
  prep
  prereq
  deploy
  get-kubeconfig
}

function provision-vpc {  ## Provision instances for cluster deployment
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function provision {  ## Provision instances for cluster deployment
  export ANSIBLE_CONFIG="/oa-testing/playbooks/ansible.cfg"
  export ANSIBLE_INVENTORY="../playbooks/inventory/hosts"
  export OPT_PLAYBOOK_BASE="../playbooks"
  export OPT_PLAYBOOK="${FUNCNAME[0]}.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function clone-openshift-ansible {  ## Clone the OpenShift-Ansible and checks out supplied tag
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function prep {  ## Prepare repos on instances
  export ANSIBLE_CONFIG="/oa-testing/playbooks/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="../playbooks"
  export OPT_PLAYBOOK="${FUNCNAME[0]}.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function prereq {  ## Run prerequisites playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="prerequisites.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function deploy {  ## Run deploy_cluster playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="deploy_cluster.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function get-kubeconfig {  ## Obtain the kubeconfig from the cluster
  set -euxo pipefail
  source build_options.sh
  REMOTEHOST=$(ansible-inventory -i "${OPT_LOCAL_DIR}/inventory/hosts" --list | jq -r '.masters.hosts[0]')
  REMOTEUSER=$(ansible-inventory -i "${OPT_LOCAL_DIR}/inventory/hosts" --list | jq -r --arg remotehost "$REMOTEHOST" '._meta.hostvars | .[$remotehost] | .ansible_user')
  mkdir --parents "${OPT_LOCAL_DIR}/assets/auth"
  ssh "${REMOTEUSER}@${REMOTEHOST}" "sudo cat /etc/origin/master/admin.kubeconfig" > "${OPT_LOCAL_DIR}/assets/auth/kubeconfig"
}

function upgrade {  ## Run cluster upgrade playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  # Pull openshift_release from inventory, grab the second item ("3.11"), change the '.' to a '_',  delete the surrounding quotes
  UPGRADE_VERSION=$(grep -e '^openshift_release:' inventory/group_vars/OSEv3.yml | awk '{ print $2 }' | sed -e 's/\./_/' | tr -d \" )
  export OPT_PLAYBOOK="byo/openshift-cluster/upgrades/v${UPGRADE_VERSION}/upgrade.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function upgrade-control-plane {  ## Run control plane upgrade playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  # Pull openshift_release from inventory, grab the second item ("3.11"), change the '.' to a '_',  delete the surrounding quotes
  UPGRADE_VERSION=$(grep -e '^openshift_release:' inventory/group_vars/OSEv3.yml | awk '{ print $2 }' | sed -e 's/\./_/' | tr -d \" )
  export OPT_PLAYBOOK="byo/openshift-cluster/upgrades/v${UPGRADE_VERSION}/upgrade_control_plane.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function upgrade-nodes {  ## Run nodes upgrade playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  # Pull openshift_release from inventory, grab the second item ("3.11"), change the '.' to a '_',  delete the surrounding quotes
  UPGRADE_VERSION=$(grep -e '^openshift_release:' inventory/group_vars/OSEv3.yml | awk '{ print $2 }' | sed -e 's/\./_/' | tr -d \" )
  export OPT_PLAYBOOK="byo/openshift-cluster/upgrades/v${UPGRADE_VERSION}/upgrade_nodes.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function master-config {  ## Run master config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-master/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function openshift-node-group {  ## Run openshift node group playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-master/openshift_node_group.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function master-scaleup {  ## Run master scaleup playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-master/scaleup.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function etcd-scaleup {  ## Run etcd scaleup playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-etcd/scaleup.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function node-scaleup {  ## Run node scaleup playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-node/scaleup.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function logging-config {  ## Run logging config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-logging/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function terminate {  ## Terminate cluster instances & VPC
  terminate-instances
  terminate-vpc
}

function terminate-instances {  ## Terminate cluster instances
  # We don't need to log this, running directly
  ../scripts/terminate-instances.sh
}

function terminate-vpc {  ## Terminate cluster VPC
  # We don't need to log this, running directly
  ../scripts/terminate-vpc.sh
}

function sync-oa {  ## Sync working openshift-ansible repo with testing repo
  run-local-script
}

function cert-check {  ## Run certificate expiry easy-mode playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-checks/certificate_expiry/easy-mode.yaml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function redeploy-cert {  ## Run certificate redeploy playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="redeploy-certificates.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function redeploy-master-cert {  ## Run master certificate redeploy playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-master/redeploy-certificates.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function redeploy-openshift-ca {  ## Run OpenShift CA redeploy playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-master/redeploy-openshift-ca.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function redeploy-service-catalog-cert {  ## Run service catalog certificate redeploy playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-service-catalog/redeploy-certificates.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function redeploy-router-cert {  ## Run hosted router certificate redeploy playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-hosted/redeploy-router-certificates.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function redeploy-registry-cert {  ## Run hosted registry certificate redeploy playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-hosted/redeploy-registry-certificates.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function node-restart {  ## Run node restart playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-node/restart.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

### Internal Functions ###
function run-local-script {  ## PRIVATE - Runs a local script and creates a log file
  LOG_DATE=$(date "+%FT%H.%M.%S")
  LOG_FILE=${LOG_DATE}-${FUNCNAME[1]}.log
  mkdir --parents logs
  "../scripts/${FUNCNAME[1]}.sh" |& tee "logs/${LOG_FILE}"
}

function script-runner {  ## PRIVATE - Runs a script in a container and creates a log file
  source build_options.sh
  LOG_DATE=$(date "+%FT%H.%M.%S")
  LOG_FILE=${LOG_DATE}-${FUNCNAME[1]}.log
  mkdir --parents logs
  ../runner/runner.sh "/oa-testing/scripts/${SCRIPT}" |& tee "logs/${LOG_FILE}"
}

function usage {  ## PRIVATE - Print usage information
  echo "Available commands are:"
  grep -oP '(?<=^function )[a-zA-Z0-9_-]+.*$' "$0" | grep -v 'PRIVATE' | awk 'BEGIN {FS=" {  ## "}; {printf"\033[36m%-30s\033[0m %s\n", $1, $2}'

}

# Check if a command is provided
if [ $# -eq 0 ]
then
  printf "\033[31mERROR - No command provided\033[0m\n" >&2
  usage
  exit 1
fi

# Check if each command given exist as a function (bash specific)
for COMMAND in "$@"
do
  if ! declare -f "$COMMAND" > /dev/null
  then
    printf "\033[31mERROR - '%s' is not a valid command \033[0m\n" "$COMMAND" >&2
    usage
    exit 1
  fi
done

# Run each command given
for COMMAND in "$@"
do
  # call command/function
  set -x
  "$COMMAND"
done
