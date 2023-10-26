#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then echo "usage: $0 version " >&2; exit 1; fi
GIT_VERSION="$1"


docker build --no-cache --progress=plain --build-arg GIT_VERSION=${GIT_VERSION} --build-arg TARGETPLATFORM="linux/amd64" -t ghcr.io/pfc-developer/restake:${GIT_VERSION} .
# --no-cache
docker push ghcr.io/pfc-developer/restake:${GIT_VERSION}

