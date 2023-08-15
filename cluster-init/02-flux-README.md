# Flux notes
you need to (create a token)[https://github.com/settings/tokens?type=beta]

it needs to have.

* Read access to metadata

* Read and Write access to Dependabot alerts, actions, administration, code, commit statuses, dependabot secrets, deployments, discussions, environments, issues, merge queues, pull requests, repository advisories, secret scanning alerts, secrets, security events, and workflows

# to create a customization

`
flux create kustomization podinfo \
  --target-namespace=default \
  --source=podinfo \
  --path="./kustomize" \
  --prune=true \
  --wait=true \
  --interval=30m \
  --retry-interval=2m \
  --health-check-timeout=3m \
  --export > ./clusters/main-cluster/podinfo-kustomization.yaml
  `

(and commit)

## open questions
still TBD how does one update the token every X days