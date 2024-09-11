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

## Mayastor
ensure 
```
grep HugePages /proc/meminfo
lsmod | grep nvme_tcp
```
and enable via 
```
echo 1024 | sudo tee /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
modprobe nvme_tcp
```
or editing sysctl.conf & modules-load via
```
echo vm.nr_hugepages = 1024 | sudo tee -a /etc/sysctl.conf
echo nvme_tcp > /etc/modules-load.d/nvme_tcp.conf
```

once rebooted and confirmed
```
kubectl label node <node_name> openebs.io/engine=mayastor
```