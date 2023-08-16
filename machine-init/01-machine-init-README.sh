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

apt update && apt-install -y gdisk
sgdisk -p /dev/nvme0n1

sgdisk -n 4:107483136:3750748814  /dev/nvme0n1
sgdisk -n 4:107483136:3750748814  /dev/nvme1n1