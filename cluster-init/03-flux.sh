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
  

  ---
  kubectl -n monitoring create secret generic slack-bot-token \
--from-literal=token=xoxb-YOUR-TOKEN

---
apiVersion: notification.toolkit.fluxcd.io/v1beta2
kind: Provider
metadata:
  name: slack-bot
  namespace: flux-system
spec:
  type: slack
  channel: flux
  address: https://slack.com/api/chat.postMessage
  secretRef:
    name: slack-bot-token
---
apiVersion: notification.toolkit.fluxcd.io/v1beta2
kind: Alert
metadata:
  name: on-call-webapp
  namespace: flux-system
spec:
  summary: "cluster addons"
  eventMetadata:
    env: "production"
    cluster: "my-cluster"
    region: "us-east-2"
  providerRef:
    name: slack-bot
  eventSeverity: info
  eventSources:
    - kind: GitRepository
      name: '*'
    - kind: Kustomization
      name: '*'
---
apiVersion: notification.toolkit.fluxcd.io/v1beta2
kind: Alert
metadata:
  name: flux-system
  namespace: flux-system
spec:
  eventSeverity: info
  eventSources:
  - kind: Kustomization
    name: '*'
    - kind: GitRepository
    name: '*'
  providerRef:
    name: slack-bot
---
apiVersion: notification.toolkit.fluxcd.io/v1beta2
kind: Alert
metadata:
  name: slack-alert
  namespace: flux-system
spec:
  eventSeverity: info
  eventSources:
  - kind: Kustomization
    name: '*'
  - kind: GitRepository
    name: '*'
  providerRef:
    name: slack-bot
---
apiVersion: notification.toolkit.fluxcd.io/v1beta2
kind: Alert
metadata:
  name: new-alert
  namespace: flux-system
spec:
  eventSeverity: info
  eventSources:
  - kind: Kustomization
    name: '*'
  - kind: GitRepository
    name: '*'
  providerRef:
    name: new-provider


--
https://discord.com/api/webhooks/xxx/xxx


kubectl -n flux-system create secret generic discord-url \
--from-literal=address=https://discord.com/api/webhooks/xxxx/xxx

flux create alert-provider new-provider \
  --type discord \
  --secret-ref discord-url \
  --channel demo-channel \
  --username flux-bot \
  --export


flux create alert new-alert \
  --provider-ref new-provider \
  --event-severity info \
  --event-source Kustomization/'*' \
  --event-source GitRepository/'*' \
  --namespace flux-system