yum install nfs-utils  -y ;
systemctl enable --now nfs-server.service;
systemctl status nfs-server.service;
systemctl enable --now rpcbind ;
systemctl enable --now firewalld ;
firewall-cmd --permanent --add-service=nfs;
firewall-cmd --permanent --add-service=rpc-bind;
firewall-cmd --permanent --add-service=mountd;
firewall-cmd --reload;
mkdir -p /opt/nfs_shared/userdir; chmod -R 777 /opt/nfs_shared/userdir ;
echo " /opt/nfs_shared/userdir 192.168.50.0/24(rw,sync,all_squash,subtree_check,no_root_squash,all_squash)" \
 > /etc/exports ;exportfs -a;systemctl restart nfs-server;
