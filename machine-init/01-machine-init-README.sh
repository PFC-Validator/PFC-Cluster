# notes for machines


installimage -a -r no -i images/Ubuntu-2204-jammy-amd64-base.tar.gz -p /boot/efi:esp:256M,/boot:ext3:1024M,/:ext4:100G -d nvme0n1 -f yes -t yes -n w-her-hel-01

installimage -l 0 -i images/Ubuntu-2204-jammy-amd64-base.tar.gz -p /boot/efi:esp:256M,/boot:ext3:1024M,/:ext4:100G -d nvme0n1 -f yes -t yes -n w-her-hel-01

for workers, enable SW Raid, Level 0 (mirror) and only allocate 100G in /
ceph/rook will 'find' the rest.