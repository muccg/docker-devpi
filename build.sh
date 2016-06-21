#!/bin/sh
#
# Script to build images
#

# break on error
set -e
set -x
set -a

DATE=`date +%Y.%m.%d`
DOCKER_DEVPI_VERSION=4.0.0

docker-compose build devpi
docker inspect muccg/devpi:latest

docker tag muccg/devpi:latest muccg/devpi:latest-${DATE}
docker tag muccg/devpi:latest muccg/devpi:${DOCKER_DEVPI_VERSION}

docker push muccg/devpi:latest
docker push muccg/devpi:latest-${DATE}
docker push muccg/devpi:${DOCKER_DEVPI_VERSION}
