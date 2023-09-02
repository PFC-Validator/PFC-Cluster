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


gpg2 --export-secret-keys --armor $KUBERNETES_GPG_KEY |
  kubectl create secret generic sops-gpg \
  --namespace=flux-system \
  --from-file=sops.asc=/dev/stdin
  