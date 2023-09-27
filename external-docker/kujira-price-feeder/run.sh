#!/usr/bin/env bash
docker kill kujira-price-feeder
docker rm  kujira-price-feeder
docker run -d --name kujira-price-feeder \
    -e ADDRESS=kujira.... \
    -e VALIDATOR=kujiravaloper1670dvuv348eynr9lsmdrhqu3g7vpmzx9ugf8fk \
    -e APISERVER=https://api.kujira.money \
    -e RPCSERVER=http://rpc.kujira.money\
    -e GRPCSERVER=grpc.kujira.money:443 \
    -e CONFIGFILE=https://raw.githubusercontent.com/PFC-Validator/PFC-Cluster/main/external-docker/kujira-price-feeder/kaiyo.toml \
    -e SEEDPHRASE="your seed phrase goes here" \
    ghcr.io/pfc-developer/kujira-price-feeder:${ORACLE_VERSION}


