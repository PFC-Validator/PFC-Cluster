#!/usr/bin/env bash
# Stolen from - https://github.com/DefiantLabs/externalPackages/tree/main/kujirad
if [ "$#" -ne 1 ]; then echo "usage: $0 oracle-price-feeder version " >&2; exit 1; fi
ORACLE_VERSION="$1"
#git clone https://github.com/Team-Kujira/oracle-price-feeder.git
#cd oracle-price-feeder/dockerfile || exit
docker build --progress=plain --build-arg ORACLE_VERSION=${ORACLE_VERSION} --build-arg TARGETPLATFORM="linux/amd64" -t ghcr.io/pfc-developer/price-feeder:${ORACLE_VERSION} .
docker push ghcr.io/pfc-developer/price-feeder:${ORACLE_VERSION}
# --no-cache
#$:${ORACLE_VERSION} .
