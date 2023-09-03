# create a new tenant

export TENANT_NAME=mainnet
flux create tenant green-team \
  --with-namespace=simple-webapp-green \ 
  --export > tenants/green-team/green-team-tenant.yaml