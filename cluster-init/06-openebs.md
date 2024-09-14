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

```
lvcreate -L 100G -n maya_01 VG-topolvm
mkfs.ext4 /dev/VG-topolvm/maya_01
mkdir -p /mnt/data/maya
mount /dev/VG-topolvm/maya_01 /mnt/data/maya

# add 
/dev/VG-topolvm/maya_01	/mnt/data/maya	ext4	defaults	0	0
to /etc/fstab

systemctl daemon-reload
mount -a
```

```
 helm upgrade openebs openebs/openebs \
        --namespace openebs --set engines.replicated.mayastor.enabled=true --reuse-values
```

once rebooted and confirmed
```
kubectl label node <node_name> openebs.io/engine=mayastor
```