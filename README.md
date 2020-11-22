#скачиваем Vagrantfile

        https://github.com/Konstantin0607/nfs_new.git

#переходим в директорию

        cd /NFS 

#запускаем образ

        vagrant up

#Vagrantfile поднимает 2 VM: сервер(nfs-serer) и клиент(nfs-client)

#на сервере расшаряется директория

#при старте nfs-client автоматически монтирует директорию с сервера

#при поднятие nfs-server запускается скрипт 1-server_script.sh
  
  1-server_script.sh


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
              echo "Enable firewall"
              sudo systemctl enable firewalld.service
              sudo systemctl start firewalld.service
              sudo firewall-cmd --permanent --add-service=nfs3
              sudo firewall-cmd --permanent --add-service=mountd
              sudo firewall-cmd --permanent --add-service=rpc-bind
              sudo firewall-cmd --reload 
               

#при поднятие nfsclient запускается скрипт 1-client_script.sh

   1-client_script.sh


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
               


#проверка примонтированного диска на клиенте

#подключаемся к клиентской VM

   vagrant ssh nfs-client
   
     lsblk

      df -h


