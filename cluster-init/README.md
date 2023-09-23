# initialize the cluster
ideally only needs to be run once.

we use 
* cilium
* cosmos-operator
* flux
* krew
## Lablel your nodes!
this cluster is using 'zone' for affinity.

for example. 
```
kubectl label node w-lsw-nl-01 provider=lsw zone=lsw-nl
```
## cilium
This just installs the basic setup. (cilium)[./01-cilium.sh]

### TODO
* add some firewalls
* restrict IPs
* don't brick the entire cluster

## cosmos operator
(might need to install this before flux)
you'll need to download another repo and run make on it. see (cosmos-operator)[../02-cosmos-operator].
you may want to comment out the chains.yaml in [kustomization](/clusters/main-cluster/flux-system/kustomization.yaml) before installing flux. (aren't you glad you read ahead?)

## flux
see (detailed readme)[./03-flux.sh]
you need a github token for this to work. i have them in (token.sh)[../token.sh.sample] 

* installs flux locally
* set's up some things to use this repo to deploy stuff.

## kustomize (needed for multi-tenancy)
```
brew install kustomize
```


## krew
helpers for rook-ceph
# manual tasks
```
kubectl label nodes w-xxx-yyy-01 provider=xxx zone=xxx-yyy
kubectl label node mynode topology.kubernetes.io/region=xxx
kubectl label node mynode topology.kubernetes.io/zone=xxx-yyy

kubectl get nodes --show-labels
```
we use provider/zone for affinity.
# topolvm
still a WIP (waiting for it to support 1.28). 
we are using localstorage for now
see (topolvm notes)[./06-topoLVM.md]


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

## remove a OSD
kubectl cordon xxxx

kubectl rook-ceph ceph osd tree
kubectl rook-ceph ceph osd stop osd.11
kubectl rook-ceph ceph osd out osd.11
kubectl rook-ceph ceph osd down osd.11
kubectl rook-ceph ceph -w
-- this may take a while
kubectl rook-ceph ceph auth del osd.11

kubectl rook-ceph ceph osd crush rm osd.11
kubectl rook-ceph ceph osd rm osd.11