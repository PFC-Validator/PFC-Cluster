#!/usr/bin/env bash
export TENANT_NAME=mainnet
export TENANT_NS=cosmos-mainnet
export GITHUB_REPO=ssh://git@github.com/PFC-Validator/PFC-Cluster-Private.git

mkdir -p ./${TENANT_NAME}

flux create tenant ${TENANT_NAME} \
  --with-namespace=${TENANT_NS} \
  --export > ./${TENANT_NAME}/${TENANT_NAME}-tenant.yaml


# this will generate a SSH deploy key that you manually need to add to the repo
# (when you run without 'export')

flux create source git ${TENANT_NAME} \
    --namespace=${TENANT_NS} \
    --url=${GITHUB_REPO} \
    --branch=main \
    --username=PFC-Developer --password=$GITHUB_TOKEN \
    --export > ./${TENANT_NAME}/${TENANT_NAME}-git.yaml


flux create kustomization ${TENANT_NAME} \
    --namespace=${TENANT_NS} \
    --service-account=${TENANT_NAME} \
    --source=GitRepository/${TENANT_NAME} \
    --path="./" \
    --export > ./${TENANT_NAME}/flux-kustomize.yaml

cd ./${TENANT_NAME}/ \
   && kustomize create --autodetect

# TBD GPG key should be different than the other one
gpg2 --export-secret-keys --armor $KUBERNETES_GPG_KEY |
  kubectl create secret generic sops-mainnet-gpg \
  --namespace=cosmos-mainnet \
  --from-file=sops.asc=/dev/stdin
  