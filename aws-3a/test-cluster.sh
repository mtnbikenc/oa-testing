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

function clone-openshift-ansible {  ## Clone the OpenShift-Ansible and checks out supplied tag
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function provision-vpc {  ## Provision instances for cluster deployment
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function provision {  ## Provision instances for cluster deployment
  export ANSIBLE_CONFIG="/oa-testing/playbooks/ansible.cfg"
  export ANSIBLE_INVENTORY="/oa-testing/playbooks/inventory/hosts"
  export OPT_PLAYBOOK_BASE="/oa-testing/playbooks"
  export OPT_PLAYBOOK="${FUNCNAME[0]}.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function prep {  ## Prepare repos on instances
  export ANSIBLE_CONFIG="/oa-testing/playbooks/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="/oa-testing/playbooks"
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
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
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

## Components Playbooks
function master-components {  ## Run master components config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-master/components.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function monitoring-config {  ## Run monitoring config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-monitoring/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function metering-config {  ## Run metering config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-metering/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function web-console-config {  ## Run web-console config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-web-console/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function console-config {  ## Run console config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-console/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function metrics-config {  ## Run metrics config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-metrics/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function metrics-server-config {  ## Run metrics config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="metrics-server/config.yml"
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

function monitor-availability-config {  ## Run monitor-availability config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-monitor-availability/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function service-catalog-config {  ## Run service-catalog config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-service-catalog/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function olm-config {  ## Run olm config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-olm/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function descheduler-config {  ## Run descheduler config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-descheduler/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function node-problem-detector-config {  ## Run node-problem-detector config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-node-problem-detector/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function autoheal-config {  ## Run autoheal config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-autoheal/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function cluster-autoscaler-config {  ## Run cluster-autoscaler config playbook
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="openshift-cluster-autoscaler/config.yml"
  SCRIPT="run-playbook.sh"
  script-runner
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

function terminate {  ## Terminate cluster instances & VPC
  terminate-instances
  terminate-vpc
}

function terminate-instances {  ## Terminate cluster instances
  export ANSIBLE_CONFIG="/oa-testing/playbooks/ansible.cfg"
  export ANSIBLE_INVENTORY="/oa-testing/playbooks/inventory/hosts"
  export OPT_PLAYBOOK_BASE="/oa-testing/playbooks"
  export OPT_PLAYBOOK="${FUNCNAME[0]}.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function terminate-vpc {  ## Terminate cluster VPC
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function sync-oa {  ## Sync working openshift-ansible repo with testing repo
  run-local-script
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
