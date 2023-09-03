#!/usr/bin/env bash
export TENANT_NAME=mainnet
export TENANT_NS=cosmos-mainnet
export GITHUB_REPO=https://github.com/PFC-Validator/PFC-Cluster-Private.git

mkdir -p ./${TENANT_NAME}

flux create tenant ${TENANT_NAME} \
  --with-namespace=${TENANT_NS} \
  --export > ./${TENANT_NAME}/${TENANT_NAME}-tenant.yaml


flux create source git ${TENANT_NAME} \
    --namespace=${TENANT_NS} \
    --url=${GITHUB_REPO} \
    --branch=main \
    --export > ./${TENANT_NAME}/${TENANT_NAME}-git.yaml


flux create kustomization ${TENANT_NAME} \
    --namespace=${TENANT_NS} \
    --service-account=${TENANT_NAME} \
    --source=GitRepository/${TENANT_NAME} \
    --path="./" \
    --export > ./${TENANT_NAME}/flux-kustomize.yaml

cd ./${TENANT_NAME}/ \
   && kustomize create --autodetect

