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


gpg2 --export-secret-keys --armor "4C653A7AD53BC071B149AC6F05C9A59CE6F61D40" |
  kubectl create secret generic sops-gpg \
  --namespace=flux-system \
  --from-file=sops.asc=/dev/stdin
  