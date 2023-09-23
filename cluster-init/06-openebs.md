# openEBS
install the VGs defined in [topoLVM](./06-topoLVM.md)
```
kubectl apply -f https://openebs.github.io/charts/lvm-operator.yaml
kubectl get pods -n kube-system -l role=openebs-lvm
```
```
helm repo add openebs https://openebs.github.io/charts
helm repo update
```

```
# we didn't do this.
# helm install openebs --namespace openebs openebs/openebs --create-namespace
```