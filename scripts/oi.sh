#!/bin/sh
set -o errexit -o pipefail -o nounset
ASSETDIR="assets"
TOKEN=""
INSTALLCONFIG=""
LOGLEVEL="DEBUG"
PULLSECRET="${HOME}/pull-secret.txt"
RELEASE="4.4"

# Parse arguments
SKIPPED=()
while [[ $# -gt 0 ]]; do case $1 in
    -d=*|--dir=*)
        ASSETDIR="${1#*=}"
	shift
        ;;
    -d|--dir)
        ASSETDIR="$2"
        shift 2
        ;;
    -h|--help)
	usage
	exit $?
	;;
    -i|--install-config)
        INSTALLCONFIG="$2"
        shift 2
        ;;
    -l=*|--log-level=*)
        LOGLEVEL="${1#*=}"
	shift
        ;;
    -l|--log-level)
        LOGLEVEL="$2"
        shift 2
        ;;
    -r|--release)
        RELEASE="$2"
        shift 2
        ;;
    -t|--token)
        TOKEN="$2"
        shift 2
        ;;
    *)
        SKIPPED+=("$1")
	shift
        ;;
esac done
set -- "${SKIPPED[@]}"

usage() {
    echo "Usage: $(basename $0) [OPTIONS]... [PARAMETERS]"
    echo "    -h, --help           help for $(basename $0)"
    echo "    -d, --dir            assets directory (default assets)"
    echo "    -i, --install-config path to existing install-config"
    echo "    -l, --log-level      log level (e.g. debug | info | warn | error) (default debug)"
    echo "    -r, --release        release image override version (e.g. 4.2, 4.3, ...)"
    echo "    -t, --token          use this token to replace auth for api.ci.openshift.org"
}

# Create the asset dir if not exists.
if [ ! -d ${ASSETDIR} ]; then
    mkdir ${ASSETDIR}
fi

# Replace the registry.svc.ci.openshift.org entry in pull-secret
if [ ! -z "${TOKEN}" ] && [ -f ${PULLSECRET} ]; then
    oc login https://api.ci.openshift.org --token="${TOKEN}" >> /dev/null
    oc registry login --to /tmp/secret.json
    echo $(jq -sc '.[0] * .[1]' ${PULLSECRET} /tmp/secret.json) > ${PULLSECRET}
    rm /tmp/secret.json
fi

# Copy the install-confg if supplied, and update the pull-secret if exists, but only if a cluster not already exists.
if [ ! -f ${ASSETDIR}/install-config.yaml ] && [ ! -f ${ASSETDIR}/.openshift_install_state.json ]; then
    if [ ! -z "${INSTALLCONFIG}" ] && [ -f ${INSTALLCONFIG} ]; then
        if [ -f ${PULLSECRET} ]; then
            PULLSECRETCONTENTS="$(<${PULLSECRET})"
            grep -v "^pullSecret: " ${INSTALLCONFIG} > ${ASSETDIR}/install-config.yaml
            echo "pullSecret: '${PULLSECRETCONTENTS}'" >> ${ASSETDIR}/install-config.yaml
        else
            cp ${INSTALLCONFIG} ${ASSETDIR}/install-config.yaml
        fi
    fi
fi

# Override the release
export OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE="registry.svc.ci.openshift.org/ocp/release:${RELEASE}"

# Run openshift-install passing unused args
time openshift-install --dir=${ASSETDIR} --log-level=${LOGLEVEL} $@
