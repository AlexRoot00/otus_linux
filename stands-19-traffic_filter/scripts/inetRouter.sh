yum install -y epel-release;
yum install -y wget libpcap* iptables-services;
wget http://li.nux.ro/download/nux/dextop/el7Server/x86_64/knock-server-0.7-2.el7.nux.x86_64.rpm -P /home/vagrant;
yum localinstall -y /home/vagrant/knock-server-0.7-2.el7.nux.x86_64.rpm;
bash -c 'echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.conf';
sysctl -p
systemctl enable iptables && systemctl start iptables;
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
iptables -t nat -A POSTROUTING ! -d 192.168.0.0/16 -o eth0 -j MASQUERADE; 
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT;
iptables -A INPUT -p tcp --dport 22 -j REJECT;
service iptables save
bash -c 'echo "192.168.0.0/16 via 192.168.255.2 dev eth1" > /etc/sysconfig/network-scripts/route-eth1';
cp /vagrant/files/knockd.conf /etc/knockd.conf;
cp /vagrant/files/knockd-inetRouter.conf /etc/sysconfig/knockd
chown root:root /etc/knockd.conf;
chmod 600 /etc/knockd.conf
chown root:root /etc/sysconfig/knockd;
chmod 644 /etc/sysconfig/knockd
cp /vagrant/files/knockd.service /etc/systemd/system/
chown root:root /etc/systemd/system/;
chmod 755 /etc/systemd/system/
systemctl daemon-reload
echo "vagrant:vagrant" | chpasswd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
service knockd start
systemctl enable knockd.service
reboot
