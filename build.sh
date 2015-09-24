#!/bin/sh
#
# Script to build images
#

# break on error
set -e

REPO="muccg"
DATE=`date +%Y.%m.%d`

image="${REPO}/devpi:latest"
echo "################################################################### ${image}"
        
## warm up cache for CI
docker pull ${image} || true

## build
docker build --pull=true -t ${image}-${DATE} .
docker build -t ${image} .

## for logging in CI
docker inspect ${image}-${DATE}

# push
docker push ${image}-${DATE}
docker push ${image}
