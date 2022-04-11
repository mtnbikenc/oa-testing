#!/usr/bin/env bash
set -euxo pipefail

newbuild=$(buildah from --pull quay.io/centos/centos:stream8)

buildah run "$newbuild" -- dnf update -y
buildah run "$newbuild" -- dnf install -y $(<packages.txt)
buildah run "$newbuild" -- dnf remove -y python36
buildah run "$newbuild" -- dnf clean all
buildah run "$newbuild" -- pip3 install --upgrade pip setuptools wheel
buildah run "$newbuild" -- pip3 install $(<requirements.txt)
buildah run "$newbuild" -- pip3 cache purge

# Download, extract and install the latest oc binary
TEMP_DIR=$(mktemp)
wget https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz --directory-prefix="${TEMP_DIR}"
tar -xzf "${TEMP_DIR}/oc.tar.gz" --directory "${TEMP_DIR}"
buildah copy "$newbuild" "${TEMP_DIR}/*" "/usr/bin"
rm -rf "${TEMP_DIR}"

# Download and install the AWS CLI
buildah run "$newbuild" -- curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
buildah run "$newbuild" -- unzip -q awscliv2.zip
buildah run "$newbuild" -- ./aws/install
buildah run "$newbuild" -- /usr/local/bin/aws --version
buildah run "$newbuild" -- rm -rf awscliv2.zip aws/

buildah copy "$newbuild" root /
buildah config --entrypoint '[ "/oa-testing/entrypoint.sh" ]' "$newbuild"

# Add a default command to run if none provided
buildah config --cmd "oc version" "$newbuild"

# Create needed directories for volume mounting
buildah run "$newbuild" -- mkdir /oa-testing/cluster
buildah run "$newbuild" -- mkdir /oa-testing/playbooks
buildah run "$newbuild" -- mkdir /oa-testing/scripts
buildah run "$newbuild" -- mkdir /root/.aws
buildah run "$newbuild" -- mkdir /root/.ssh

# Save the built image
buildah commit "$newbuild" "oa-runner-base"

# Remove the temporary container
buildah rm "$newbuild"
