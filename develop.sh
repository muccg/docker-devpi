#!/bin/sh
set +x
set -e

: "${CCG_DOCKER_ORG:=muccg}"
: "${CCG_COMPOSER:=ccg-composer}"
: "${CCG_COMPOSER_VERSION:=latest}"
: "${CCG_PIP_PROXY=0}"
: "${CCG_HTTP_PROXY=0}"

export CCG_DOCKER_ORG CCG_COMPOSER CCG_COMPOSER_VERSION CCG_PIP_PROXY CCG_HTTP_PROXY

# ensure we have an .env file
ENV_FILE_OPT=''
if [ -f .env ]; then
    ENV_FILE_OPT='--env-file .env'
    set +e
    . ./.env > /dev/null 2>&1
    set -e
else
    echo ".env file not found, settings such as project name and proxies will not be set"
fi

# Pass through the ip of the host if we can
# There is no docker0 interface on Mac OS, so don't do any proxy detection
if [ "$(uname)" != "Darwin" ]; then
    set +e
    DOCKER_ROUTE=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')
    set -e
    export DOCKER_ROUTE
fi

TTY_OPTS=
if [ -t 0 ]; then
    TTY_OPTS='--interactive --tty'
fi

ENV_OPTS="$(env | sort | cut -d= -f1 | grep "^CCG_[a-zA-Z0-9_]*$" | awk '{print "-e", $1}')"
# shellcheck disable=SC2086 disable=SC2048
docker run --rm ${TTY_OPTS} ${ENV_FILE_OPT} \
    ${ENV_OPTS} \
    -v /etc/timezone:/etc/timezone:ro \
    -v /var/run/docker.sock:/var/run/docker.sock  \
    -v "$(pwd)":"$(pwd)" \
    -v "${HOME}"/.docker:/data/.docker \
    -w "$(pwd)" \
    "${CCG_DOCKER_ORG}"/"${CCG_COMPOSER}":"${CCG_COMPOSER_VERSION}" \
    "$@"
