# topoLVM
this is a work in progress. I am not using it yet.

## intro
This is still manual, but will eventually go into ansible.
main readme is here - https://github.com/topolvm/topolvm/blob/main/deploy/README.md
# sgdisk -N=0 -s /dev/nvme2n1

## create the Volume Group
### NVMe example
sgdisk -p /dev/nvme0n1
sgdisk -p /dev/nvme1n1
sgdisk -p /dev/nvme2n1
sgdisk -p /dev/nvme3n1

partprobe

blkdiscard /dev/nvme2n1p4 -f
blkdiscard /dev/nvme3n1p4 -f

blkdiscard /dev/nvme0n1 -f
blkdiscard /dev/nvme1n1 -f
partprobe
pvcreate /dev/nvme2n1p4 /dev/nvme3n1p4 /dev/nvme0n1 /dev/nvme1n1
vgcreate VG-topolvm /dev/nvme0n1p4 /dev/nvme1n1p4 /dev/nvme2n1 /dev/nvme3n1
vgs

### SDA example
dd if=/dev/zero of=/dev/sda bs=1M count=1000
dd if=/dev/zero of=/dev/sdb bs=1M count=1000

partprobe
pvcreate /dev/sda /dev/sdb
vgcreate VG-topolvm /dev/sda /dev/sdb
vgs

## install LVMd
https://github.com/topolvm/topolvm/releases

curl -LO https://github.com/topolvm/topolvm/releases/download/v0.21.0/lvmd-0.21.0.tar.gz
tar xfz lvmd-0.21.0.tar.gz
curl -LO https://github.com/topolvm/topolvm/raw/main/deploy/lvmd-config/lvmd.yaml
curl -LO https://github.com/topolvm/topolvm/raw/main/deploy/systemd/lvmd.service