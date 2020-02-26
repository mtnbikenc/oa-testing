#!/bin/bash
if [ -z $1 ]; then
  TARGETDIR='assets'
else
  TARGETDIR=$1
fi
if [ -f build_options.sh ]; then
  source build_options.sh
fi
while true; do
  if [ -f ${TARGETDIR}/metadata.json ]; then
    if [ "$(jq '.aws' ${TARGETDIR}/metadata.json)" != "null" ]; then
      IP=$(jq '.resources[] | select(.module == "module.bootstrap") | select(.type == "aws_instance") | select(.name == "bootstrap") | .instances[0].attributes.public_ip' ${TARGETDIR}/terraform.tfstate | tr -d "\"")
    fi;
    if [ "$(jq '.gcp' ${TARGETDIR}/metadata.json)" != "null" ]; then
      IP=$(jq '.resources[] | select(.module == "module.bootstrap") | select(.type == "google_compute_address") | select(.name == "bootstrap") | .instances[0].attributes.address' ${TARGETDIR}/terraform.tfstate | tr -d "\"")
    fi;
  else
    echo "${TARGETDIR}/metadata.json not found"
    IP=""
  fi

  if [ -n "${IP}" ];
  then
    ssh -i ${OPT_PRIVATE_KEY:-'~/.ssh/openshift-dev.pem'} \
      -o ConnectTimeout=5 \
      -o StrictHostKeyChecking=no \
      -o PasswordAuthentication=no \
      -o UserKnownHostsFile=/dev/null \
      core@${IP} \
      'journalctl -b -f -u release-image.service -u bootkube.service'
  fi
  sleep 10
done;
