# notes for machines


installimage -a -r no -i images/Ubuntu-2204-jammy-amd64-base.tar.gz -p /boot/efi:esp:256M,/boot:ext3:1024M,/:ext4:100G -d nvme0n1 -f yes -t yes -n w-her-hel-01

installimage -l 0 -i images/Ubuntu-2204-jammy-amd64-base.tar.gz -p /boot/efi:esp:256M,/boot:ext3:1024M,/:ext4:100G -d nvme0n1 -f yes -t yes -n w-her-hel-01

for workers, enable SW Raid, Level 0 (mirror) and only allocate 100G in /
ceph/rook will 'find' the rest, once you create the partions.

kubectl run -it --rm \
    -n rook-ceph                \
    --image ubuntu:latest       \
    --privileged                \
    --overrides='{"spec": { "nodeSelector": {"kubernetes.io/hostname": "w-her-hel-01.medici.loan"}}}' ubu-h

apt update && apt install -y gdisk
sgdisk -p /dev/nvme0n1ß

# AX102
sgdisk -n 4:107483136:3750748814  /dev/nvme0n1
sgdisk -n 4:107483136:3750748814  /dev/nvme1n1


# OVH
sgdisk -n 5:105545728:1875380911  /dev/nvme0n1
sgdisk -n 4:105545728:1875380911  /dev/nvme1n1
#
sgdisk -N=0 -s /dev/nvme1n1


kubectl run -it --rm \
    -n rook-ceph                \
    --image  quay.io/ceph/ceph:v17.2.6      \
    --privileged                \
    --overrides='{"spec": { "nodeSelector": {"kubernetes.io/hostname": "w-ovh-war-01.medici.loan"}}}' ceph-shell
##    
kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') -- bash

## you may need to restart the ceph operator
kubectl rook-ceph operator restart
# you may also need to resatart some of the rook-discover pods
kubectl rook-ceph ceph status


| node     | provider| zone |
| -------- | ---- | ------ |
| w-her-fsn-01 | her | fsn |
| w-her-fsn-02 | her | fsn |
| w-her-hel-01 | her | hel |
| w-ovh-fra-01 | ovh | hel |
| c-lsw-nl-contrrol | lsw | nl |
..
# eg
kubectl label nodes w-ovh-war-01.xxx.xxx provider=ovh zone=war
kubectl get nodes --show-labels