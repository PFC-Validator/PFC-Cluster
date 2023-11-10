#!/usr/bin/env bash
# for testing
docker kill hermes 2>&1 >/dev/null
docker rm   hermes 2>&1 >/dev/null

docker run -d --name hermes \
    -p 3000:3000 \
    -p 3001:3001 \
    -e CONFIGFILE=/config/ \
    -v ./config/init:/init \
    -v ./test/keys:/keys \
    -v ./test/config:/config \
     ghcr.io/pfc-developer/hermes:v1.7.0
