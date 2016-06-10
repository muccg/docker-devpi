#!/bin/sh
#
# Script to build images
#

# break on error
set -e
set -x
set -a

DATE=`date +%Y.%m.%d`
COMPOSE='docker-compose -f docker-compose-build.yml run docker19'

. ./vars.env

## warm up cache for CI
docker pull ${IMAGE} || true

${COMPOSE} build --pull=true --build-arg ARG_DEVPI_VERSION=${DEVPI_VERSION} -t ${IMAGE}:latest /data
${COMPOSE} inspect ${IMAGE}:latest

${COMPOSE} tag -f ${IMAGE}:latest ${IMAGE}:latest-${DATE}
${COMPOSE} tag -f ${IMAGE}:latest ${IMAGE}:${DEVPI_VERSION}

${COMPOSE} push ${IMAGE}:latest
${COMPOSE} push ${IMAGE}:latest-${DATE}
${COMPOSE} push ${IMAGE}:${DEVPI_VERSION}
