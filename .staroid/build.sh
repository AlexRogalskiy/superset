#!/bin/bash
# Custom builder script for Skaffold
# https://skaffold.dev/docs/pipeline-stages/builders/custom/
#

set -x
set -e
pwd

SUPERSET_REPO=https://github.com/apache/superset.git
SUPERSET_CHECKOUT=master

# Checkout source
if [ ! -d "superset" ]; then
    git clone $SUPERSET_REPO superset
fi
cd superset
git checkout $SUPERSET_CHECKOUT

# Patch dockerfile
cat ../Dockerfile_staroid >> Dockerfile
cp ../requirements-staroid.txt ./

docker build -t $IMAGE -f Dockerfile .
docker images

if $PUSH_IMAGE; then
    docker push $IMAGE
fi
