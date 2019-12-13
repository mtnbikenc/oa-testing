#!/usr/bin/env bash
set -euxo pipefail

newbuild=$(buildah from registry.fedoraproject.org/f30/fedora-toolbox:30)

#buildah run "$newbuild" -- dnf update -y
buildah run "$newbuild" -- dnf install -y ansible python3-boto python3-boto3 python3-pyOpenSSL expect jq zsh
buildah run "$newbuild" -- wget https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz --directory-prefix=/tmp
buildah run "$newbuild" -- tar -xzf /tmp/oc.tar.gz --directory /usr/bin

buildah commit "$newbuild" "oa-testing-base"

buildah rm "$newbuild"
