docker-devpi
============

This repository contains a Dockerfile for devpi pypi server

http://doc.devpi.net/latest/

Installation

`docker pull muccg/docker-devpi`

Quickstart

Start using 

```
docker run -d --name devpi \
    --publish 3141:3141 \
    --volume /srv/docker/devpi:/data \
    --env=DEVPI_PASSWORD=changemetoyoulongsecret \
    --restart always \
    muccg/docker-devpi
```
Devpi creates a user named root by default, its password can be set with DEVPI_PASSWORD environment variable. Please set it, otherwise attacker can *execute arbitrary code* in your application by uploading modified packages.

Persistence

For devpi to preserve its state across container shutdown and startup you should mount a volume at `/data`. The quickstart command already includes this.

Security

Devpi creates a user named root by default, its password can be set with DEVPI_PASSWORD environment variable. Please set it, otherwise attacker can *execute arbitrary code* in your application by uploading modified packages.

Usage

To use this devpi cache to speed up your dockerfile builds, add pip as an optional cache:

```Dockerfile
# configure apt to not install reccomendations
RUN apt-get update \
 && apt-get install -y netcat \
 && rm -rf /var/lib/apt/lists/*
 
 # Use an optional pip cache to speed development
RUN export HOST_IP=$(ip route| awk '/^default/ {print $3}') \
 && mkdir -p ~/.pip \
 && echo [global] >> ~/.pip/pip.conf \
 && echo extra-index-url = http://$HOST_IP:3141/app/dev/+simple >> ~/.pip/pip.conf \
 && echo [install] >> ~/.pip/pip.conf \
 && echo trusted-host = $HOST_IP >> ~/.pip/pip.conf \
 && cat ~/.pip/pip.conf
```

