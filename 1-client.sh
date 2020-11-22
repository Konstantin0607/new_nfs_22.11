#!/bin/bash

set -eux

echo "HM4"
whoami
uname -a
hostname -f
ip addr show dev eth1

echo "Mount NFSv3 UDP"
#sudo mount.nfs -vv 192.168.10.10:/export/shared /mnt -o nfsvers=3,proto=udp,soft
#mount | grep nfs
#sudo umount /mnt

echo "Test mount NFSv4"
#sudo mount 192.168.10.10:/export/shared /mnt
#mount | grep nfs
#sudo umount /mnt

sudo -i

yum install -y nfs-utils

systemctl enable firewalld
systemctl start firewalld


echo "192.168.10.10:/usr/shared /mnt nfs rw,vers=3,sync,proto=udp,rsize=32768,wsize=32768 0 0" >> /etc/fstab

mount /mnt/

