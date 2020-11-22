#!/bin/bash

set -eux

echo "HM4"
whoami
uname -a
hostname -f
ip addr show dev eth1

echo "Place here your commands for provisioning"

sudo yum install -y nfs-utils

sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl enable rpc-statd
sudo systemctl enable nfs-idmapd

sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo systemctl start rpc-statd
sudo systemctl start nfs-idmapd

sudo mkdir -p /usr/shared
sudo chmod 0777 /usr/shared
sudo cat << EOF | sudo tee /etc/exports
/usr/shared  192.168.10.0/24(rw,async)
EOF

sudo exportfs -ra
sudo systemctl enable firewalld.service
sudo systemctl start firewalld.service

sudo firewall-cmd --permanent --add-service=nfs3
sudo firewall-cmd --permanent --add-service=mountd
sudo firewall-cmd --permanent --add-service=rpc-bind
sudo firewall-cmd --reload

sudo mkdir /usr/shared/uploads

