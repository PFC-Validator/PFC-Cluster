# initialize the cluster
ideally only needs to be run once.

we use 
* cilium
* flux
* cosmos-operator
* krew

## cilium
This just installs the basic setup. (cilium)[./01-cilium.sh]

### TODO
* add some firewalls
* restrict IPs
* don't brick the entire cluster

## flux
see (detailed readme)[./02-flux.sh]
you need a github token for this to work. i have them in (token.sh)[../token.sh.sample] 

* installs flux locally
* set's up some things to use this repo to deploy stuff.

## cosmos operator
(might need to install this before flux)
you'll need to download another repo and run make on it. see (cosmos-operator)[../03-cosmos-operator].
you may want to comment out the chains.yaml in [kustomization](/clusters/main-cluster/flux-system/kustomization.yaml) before installing flux. (aren't you glad you read ahead?)

## krew
helpers for rook-ceph

# rook-ceph issues
# check if the disks are found
this still doesn't work right first time.
```
kubectl rook-ceph ceph status
```
and
```
kubectl -n rook-ceph get pods -o wide |grep osd|grep -v prepare
```
you should see 2 'osds' on worker.
## potential things to try
if not.. time to go and manually play with sgdisk, and do
```
kubectl rook-ceph operator restart
```


this may help you recoving
```
kubectl -n rook-ceph patch cephcluster rook-ceph --type merge -p '{"spec":{"cleanupPolicy":{"confirmation":"yes-really-destroy-data"}}}'
```
or (rtfm)[https://rook.io/docs/rook/v1.11/Getting-Started/ceph-teardown/#removing-the-cluster-crd-finalizer] it.