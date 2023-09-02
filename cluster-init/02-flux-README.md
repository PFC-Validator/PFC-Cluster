# Flux notes
you need to (create a token)[https://github.com/settings/tokens?type=beta]

it needs to have.

* Read access to metadata

* Read and Write access to Dependabot alerts, actions, administration, code, commit statuses, dependabot secrets, deployments, discussions, environments, issues, merge queues, pull requests, repository advisories, secret scanning alerts, secrets, security events, and workflows
# create GPG key
export KEY_NAME="cluster0.yourdomain.com"
export KEY_COMMENT="flux secrets"

gpg --batch --full-generate-key <<EOF
%no-protection
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Expire-Date: 0
Name-Comment: ${KEY_COMMENT}
Name-Real: ${KEY_NAME}
EOF

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

# secrets 
you will also need to create a GPG2 key and put that up in the secret manager.
this should match what the (sops.yaml)[../.sops.yaml] contains.

## open questions
still TBD how does one update the token every X days


# commands that are useful
`
flux get kustomizations --watch
`