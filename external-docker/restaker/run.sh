#!/usr/bin/env bash
source .env
docker kill restake
docker rm restake
docker run -d --name restake  \
	-v ./config:/config \
	-e MNEMONIC="$MNEMONIC" \
	-e NETWORKS_OVERRIDE_PATH="/config/networks.local.json" \
	ghcr.io/pfc-developer/restake:v2.11.1 
