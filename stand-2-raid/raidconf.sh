#!/bin/bash

mkdir /etc/mdadm && cd /etc/mdadm && touch mdadm.conf
mdadm --zero-superblock dev/sd{b,c,d,e,f,g} 
mdadm --create --verbose /dev/md/raid5 --level=5 --raid-devices=6 /dev/sd{b,c,d,e,f,g};
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
parted -a opt /dev/md127 mkpart primary xfs 0% 100%;


