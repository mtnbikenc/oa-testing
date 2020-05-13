#!/usr/bin/env bash
set -euo pipefail

function build {  ## Build an OpenShift cluster
  clone-ansible
  clone-openshift-ansible
  provision
  prep
  prereq
  deploy
}

function provision {  ## Provision instances for cluster deployment
  export ANSIBLE_INVENTORY="../playbooks/inventory/hosts"
  export PLAYBOOK_BASE="../playbooks"
  export PLAYBOOK="provision.yml"
  export SCRIPT="run-playbook.sh"
  run-script
}

function clone-ansible {  ## Clone the Ansible repo and checks out supplied tag
  export SCRIPT="clone-ansible.sh"
  run-script
}

function clone-openshift-ansible {  ## Clone the OpenShift-Ansible and checks out supplied tag
  export SCRIPT="clone-openshift-ansible.sh"
  run-script
}

function prep {  ## Prepare repos on instances
  export ANSIBLE_INVENTORY="inventory/hosts"
  export PLAYBOOK_BASE="../playbooks"
  export PLAYBOOK="prep.yml"
  export SCRIPT="run-playbook.sh"
  run-script
}

function prereq {  ## Run prerequisites playbook
  export ANSIBLE_INVENTORY="inventory/hosts"
  export PLAYBOOK_BASE="openshift-ansible"
  export PLAYBOOK="playbooks/prerequisites.yml"
  export SCRIPT="run-playbook.sh"
  run-script
}

function deploy {  ## Run deploy_cluster playbook
  export ANSIBLE_INVENTORY="inventory/hosts"
  export PLAYBOOK_BASE="openshift-ansible"
  export PLAYBOOK="playbooks/deploy_cluster.yml"
  export SCRIPT="run-playbook.sh"
  run-script
}

function upgrade {  ## Run cluster upgrade playbook
  export ANSIBLE_INVENTORY="inventory/hosts"
  export PLAYBOOK_BASE="openshift-ansible"
  # Pull openshift_release from inventory, grab the second item ("3.11"), change the '.' to a '_',  delete the surrounding quotes
  UPGRADE_VERSION=$(grep -e '^openshift_release:' inventory/group_vars/OSEv3.yml | awk '{ print $2 }' | sed -e 's/\./_/' | tr -d \" )
  export PLAYBOOK="playbooks/byo/openshift-cluster/upgrades/v${UPGRADE_VERSION}/upgrade.yml"
  export SCRIPT="run-playbook.sh"
  run-script
}

function master-scaleup {  ## Run master scaleup playbook
  export ANSIBLE_INVENTORY="inventory/hosts"
  export PLAYBOOK_BASE="openshift-ansible"
  export PLAYBOOK="playbooks/openshift-master/scaleup.yml"
  export SCRIPT="run-playbook.sh"
  run-script
}

function etcd-scaleup {  ## Run etcd scaleup playbook
  export ANSIBLE_INVENTORY="inventory/hosts"
  export PLAYBOOK_BASE="openshift-ansible"
  export PLAYBOOK="playbooks/openshift-etcd/scaleup.yml"
  export SCRIPT="run-playbook.sh"
  run-script
}

function node-scaleup {  ## Run node scaleup playbook
  export ANSIBLE_INVENTORY="inventory/hosts"
  export PLAYBOOK_BASE="openshift-ansible"
  export PLAYBOOK="playbooks/openshift-node/scaleup.yml"
  export SCRIPT="run-playbook.sh"
  run-script
}

function logging-config {  ## Run logging config playbook
  export ANSIBLE_INVENTORY="inventory/hosts"
  export PLAYBOOK_BASE="openshift-ansible"
  export PLAYBOOK="playbooks/openshift-logging/config.yml"
  export SCRIPT="run-playbook.sh"
  run-script
}

function terminate {  ## Terminate cluster instances
  # We don't need to log this, running directly
  ../scripts/terminate.sh
}

function sync-oa {  ## Sync working openshift-ansible repo with testing repo
  export SCRIPT="sync-oa.sh"
  run-script
}

function cert-check {  ## Run certificate expiry easy-mode playbook
  export ANSIBLE_INVENTORY="inventory/hosts"
  export PLAYBOOK_BASE="openshift-ansible"
  export PLAYBOOK="playbooks/openshift-checks/certificate_expiry/easy-mode.yaml"
  export SCRIPT="run-playbook.sh"
  run-script
}

function redeploy-cert {  ## Run certificate redeploy playbook
  export ANSIBLE_INVENTORY="inventory/hosts"
  export PLAYBOOK_BASE="openshift-ansible"
  export PLAYBOOK="playbooks/redeploy-certificates.yml"
  export SCRIPT="run-playbook.sh"
  run-script
}

function redeploy-ca {  ## Run OpenShift CA redeploy playbook
  export ANSIBLE_INVENTORY="inventory/hosts"
  export PLAYBOOK_BASE="openshift-ansible"
  export PLAYBOOK="playbooks/openshift-master/redeploy-openshift-ca.yml"
  export SCRIPT="run-playbook.sh"
  run-script
}


### Internal Functions ###
function run-script {  ## PRIVATE - Runs a script and creates a log file
  LOG_DATE=$(date "+%FT%H.%M.%S")
  LOG_FILE=${LOG_DATE}-${FUNCNAME[1]}.log
  mkdir --parents logs
  unbuffer "../scripts/${SCRIPT}" |& tee "logs/${LOG_FILE}"
  # Strip colors from log file
  sed --in-place --regexp-extended "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" "logs/${LOG_FILE}"
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
