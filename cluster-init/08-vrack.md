# Vrack.
1. assign boxes to vrack
2. purchase a IP-block (xxx.xxx.xxx.NNN/30 - 4 addresses 1 usable.)
3. on each box in the vrack

vim /etc/netplan/50-cloud-init.yaml

add

        xxxxx1np1:
         dhcp4: no
         addresses:
         - 192.168.0.X/16
         - xx.xxx.xxx.181/30
         gateway4: xxx.xxx.xxx.182
         nameservers:
               addresses: [8.8.8.8,4.4.4.4]

 netplan apply
