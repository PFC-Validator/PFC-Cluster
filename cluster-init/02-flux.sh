#!/usr/bin/env bash
if [ ! -f "../token.sh" ]; then
    echo "missing ../token.sh ??"
    exit 
fi

brew install fluxcd/tap/flux
source ../token.sh 
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=PFC-Cluster \
  --branch=main \
  --path=./clusters/main-cluster \

  # might need --personal for individual github accounts