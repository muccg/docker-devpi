#!/bin/sh
#
# Script to build images
#

# break on error
set -e

REPO="muccg"
DATE=`date +%Y.%m.%d`

DEVPI_VERSION="2.5.3"

# ALternative config to use local proxy
#DOCKER_HOST=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')
#HTTP_PROXY="http://${DOCKER_HOST}:3128"
#PIP_INDEX_URL="http://${DOCKER_HOST}:3141/root/pypi/+simple/"
#PIP_TRUSTED_HOST=${DOCKER_HOST}
#: ${DOCKER_BUILD_OPTIONS:="--no-cache --pull=true --build-arg PIP_TRUSTED_HOST=${PIP_TRUSTED_HOST} --build-arg PIP_INDEX_URL=${PIP_INDEX_URL} --build-arg DEVPI_VERSION=${DEVPI_VERSION}"}

: ${DOCKER_BUILD_OPTIONS:="--pull=true --build-arg DEVPI_VERSION=${DEVPI_VERSION}"}

image="${REPO}/devpi"
echo "################################################################### ${image}"
## warm up cache for CI
docker pull ${image} || true

for tag in "${image}:latest" "${image}:latest-${DATE}" "${image}:${DEVPI_VERSION}"; do
    echo "############################################################# ${tag}"
    set -x
    docker build ${DOCKER_BUILD_OPTIONS} -t ${tag} .
    docker inspect ${tag}
    docker push ${tag}
    set +x
done
