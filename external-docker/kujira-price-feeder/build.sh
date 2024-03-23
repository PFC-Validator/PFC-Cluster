#!/usr/bin/env bash
# Stolen from - https://github.com/DefiantLabs/externalPackages/tree/main/kujirad
if [ "$#" -ne 1 ]; then echo "usage: $0 oracle-price-feeder version " >&2; exit 1; fi
ORACLE_VERSION="$1"
#git clone https://github.com/Team-Kujira/oracle-price-feeder.git
#cd oracle-price-feeder/dockerfile || exit
#--no-cache
docker build \
	--progress=plain \
	--build-arg VERSION=v0.9.1 \
	--build-arg ORACLE_VERSION=${ORACLE_VERSION} \
	-t ghcr.io/pfc-developer/kujira-price-feeder:${ORACLE_VERSION} .
#	--build-arg TARGETPLATFORM="linux/amd64" \
# --no-cache
echo docker push ghcr.io/pfc-developer/kujira-price-feeder:${ORACLE_VERSION}
#$:${ORACLE_VERSION} .
