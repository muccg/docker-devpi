#!/bin/sh
#
# Script to build images
#

# break on error
set -e
set -x
set -a
: ${DOCKER_USE_HUB:="0"}

DATE=`date +%Y.%m.%d`
DOCKER_DEVPI_VERSION=4.1.0


ci_docker_login() {
    info 'Docker login'

    if [ -z ${DOCKER_EMAIL+x} ]; then
        DOCKER_EMAIL=${bamboo_DOCKER_EMAIL}
    fi
    if [ -z ${DOCKER_USERNAME+x} ]; then
        DOCKER_USERNAME=${bamboo_DOCKER_USERNAME}
    fi
    if [ -z ${DOCKER_PASSWORD+x} ]; then
        DOCKER_PASSWORD=${bamboo_DOCKER_PASSWORD}
    fi

    docker login -e "${DOCKER_EMAIL}" -u ${DOCKER_USERNAME} --password="${DOCKER_PASSWORD}"
    success "Docker login"
}


# warm up cache
docker pull muccg/devpi:latest || true

docker-compose build devpi
docker inspect muccg/devpi:latest

docker tag muccg/devpi:latest muccg/devpi:latest-${DATE}
docker tag muccg/devpi:latest muccg/devpi:${DOCKER_DEVPI_VERSION}

if [ ${DOCKER_USE_HUB} = "1" ]; then
    ci_docker_login
    docker push muccg/devpi:latest
    docker push muccg/devpi:latest-${DATE}
    docker push muccg/devpi:${DOCKER_DEVPI_VERSION}
fi
