yum install nfs-utils  -y ;
systemctl enable --now nfs-server.service;
systemctl status nfs-server.service;
systemctl enable --now rpcbind ;
systemctl enable --now firewalld ;
firewall-cmd --permanent --add-service=nfs;
firewall-cmd --permanent --add-service=rpc-bind;
firewall-cmd --permanent --add-service=mountd;
firewall-cmd --reload;
mkdir /data;
mount -t nfs 192.168.50.10:/opt/nfs_shared/userdir /data;
touch /data/test.txt
echo "192.168.50.10:/opt/nfs_shared/userdir/    /data   nfs noauto,x-systemd.automount, 0 0 " \
> /etc/fstab