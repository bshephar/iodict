#!/bin/bash
set -ex

SCRIPT_DIR=$(dirname $(readlink -f $0))
CONTAINER_NAME=localhost/centos8-builder

pushd ${SCRIPT_DIR}/../
  name=${PWD##*/}
  pushd ..
  tar -czf /tmp/iodict.tar.gz "${name}"
  mv /tmp/iodict.tar.gz ${SCRIPT_DIR}/container-build/
  popd
popd

export RELEASE_VERSION=$(awk -F'"' '/version/ {print $2}' ${SCRIPT_DIR}/../iodict/meta.py)

buildah bud -t ${CONTAINER_NAME} ${SCRIPT_DIR}/container-build
podman run -it -v ${SCRIPT_DIR}:/home/builder/rpm:z ${CONTAINER_NAME}:latest --env RELEASE_VERSION="${RELEASE_VERSION}"
