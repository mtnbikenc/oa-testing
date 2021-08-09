#!/usr/bin/env bash
set -euo pipefail

function build {  ## Build an OpenShift cluster and add worker nodes
  extract-installer
  create-install-assets
  create-cluster
  clone-openshift-ansible
  create-bastion
  create-machines
#  provision40
  prep40
  scaleup
#  drain-coreos
}

function extract-installer {  ## Extract openshift-installer from the release image
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function compile-installer {  ## Compile openshift-installer from source
  run-local-script
}

function create-install-assets {  ## Create install assets, i.e. install-config.yaml
  export ANSIBLE_CONFIG="/oa-testing/playbooks/ansible.cfg"
  export ANSIBLE_INVENTORY="/oa-testing/playbooks/inventory/hosts"
  export OPT_PLAYBOOK_BASE="../playbooks"
  export OPT_PLAYBOOK="${FUNCNAME[0]}.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function create-cluster {  ## Run openshift-install to create a cluster
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function clone-openshift-ansible {  ## Clone the OpenShift-Ansible and checks out supplied tag
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function create-bastion {  ## Create SSH Bastion Host on the OpenShift cluster
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function create-machines {  ## Create worker machines on the OpenShift cluster
  export ANSIBLE_CONFIG="/oa-testing/playbooks/ansible.cfg"
  export ANSIBLE_INVENTORY="/oa-testing/playbooks/inventory/hosts"
  export OPT_PLAYBOOK_BASE="../playbooks"
  export OPT_PLAYBOOK="${FUNCNAME[0]}.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function provision40 {  ## Provision worker machines without using machinesets
  export ANSIBLE_CONFIG="/oa-testing/playbooks/ansible.cfg"
  export ANSIBLE_INVENTORY="/oa-testing/playbooks/inventory/hosts"
  export OPT_PLAYBOOK_BASE="../playbooks"
  export OPT_PLAYBOOK="${FUNCNAME[0]}.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function prep40 {  ## Prepare repos on worker machines
  export ANSIBLE_CONFIG="/oa-testing/playbooks/ansible.cfg"
  export ANSIBLE_INVENTORY="/oa-testing/cluster/inventory/hosts"
  export OPT_PLAYBOOK_BASE="../playbooks"
  export OPT_PLAYBOOK="${FUNCNAME[0]}.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function scaleup {  ## Run openshift-ansible to scale up worker nodes
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="/oa-testing/cluster/inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="${FUNCNAME[0]}.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function drain-coreos {  ## Drain CoreOS worker nodes
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function remove-coreos {  ## Remove CoreOS worker nodes
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function upgrade {  ## Run openshift-ansible to upgrade worker nodes
  export ANSIBLE_CONFIG="/oa-testing/cluster/openshift-ansible/ansible.cfg"
  export ANSIBLE_INVENTORY="/oa-testing/cluster/inventory/hosts"
  export OPT_PLAYBOOK_BASE="openshift-ansible/playbooks"
  export OPT_PLAYBOOK="${FUNCNAME[0]}.yml"
  SCRIPT="run-playbook.sh"
  script-runner
}

function drain-rhel {  ## Drain RHEL worker nodes
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function unscaleup {  ## Remove added worker nodes from cluster
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function rescaleup {  ## Run 'create-machines', 'prep40' and 'scaleup'
  create-machines
#  provision40
  prep40
  scaleup
#  drain-coreos
}

function destroy {  ## Destroy OpenShift cluster and clean up artifacts
  SCRIPT="${FUNCNAME[0]}.sh"
  script-runner
}

function sync-oa {  ## Sync working openshift-ansible repo with testing repo
  run-local-script
}

function e2e-tests {  ## Run openshift e2e tests
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
