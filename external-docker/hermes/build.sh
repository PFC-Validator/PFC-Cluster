#!/usr/bin/env bash
if [ "$#" -ne 1 ]; then echo "usage: $0 hermes-version " >&2; exit 1; fi
VERSION="$1"

docker build  --progress=plain --build-arg VERSION=${VERSION} --build-arg TARGETPLATFORM="linux/amd64" -t ghcr.io/pfc-developer/hermes:${VERSION} .
# --no-cache
docker push ghcr.io/pfc-developer/hermes:${VERSION}

