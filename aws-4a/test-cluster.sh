#!/usr/bin/env bash
set -euo pipefail

function build {  ## Build an OpenShift cluster and add worker nodes
  extract-installer
  create-install-assets
  create-cluster
  clone-ansible
  clone-openshift-ansible
  create-bastion
#  create-machines
  provision40
  prep40
  node-scaleup40
}

function extract-installer {  ## Extract openshift-installer from the release image
  run-script
}

function create-install-assets {  ## Create install assets, i.e. install-config.yaml
  run-script
}

function create-cluster {  ## Run openshift-install to create a cluster
  run-script
}

function clone-ansible {  ## Clone the Ansible repo and checks out supplied tag
  run-script
}

function clone-openshift-ansible {  ## Clone the OpenShift-Ansible and checks out supplied tag
  run-script
}

function create-bastion {  ## Create SSH Bastion Host on the OpenShift cluster
  run-script
}

function create-machines {  ## Create worker machines on the OpenShift cluster
  run-script
}

function provision40 {  ## Prepare repos on worker machines
  run-script
}

function prep40 {  ## Prepare repos on worker machines
  run-script
}

function node-scaleup40 {  ## Run openshift-ansible to scale up worker nodes
  run-script
}

function upgrade40 {  ## Run openshift-ansible to upgrade worker nodes
  run-script
}

function unscaleup {  ## Remove added worker nodes from cluster
  run-script
}

function rescaleup {  ## Run 'create-machines', 'prep40' and 'node-scaleup40'
#  create-machines
  provision40
  prep40
  node-scaleup40
}

function destroy {  ## Destroy OpenShift cluster and clean up artifacts
  # We don't need to log this, running directly
  ../scripts/destroy.sh
}

function sync-oa {  ## Sync working openshift-ansible repo with testing repo
  run-script
}

### Internal Functions ###
function run-script {  ## PRIVATE - Runs a script and creates a log file
  LOG_DATE=$(date "+%FT%H.%M.%S")
  LOG_FILE=${LOG_DATE}-${FUNCNAME[1]}.log
  mkdir --parents logs
  unbuffer "../scripts/${FUNCNAME[1]}.sh" |& tee "logs/${LOG_FILE}"
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
