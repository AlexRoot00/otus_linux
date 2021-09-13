yum install -y epel-release
yum install -y openvpn iperf3 
setenforce 0
sed -i 's/=enforcing/=disabled/g' /etc/selinux/config
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
 iptables -A OUTPUT -p tcp -m tcp --dport 1194 -j ACCEPT 
 iptables -A OUTPUT -p udp -m udp --dport 1194 -j ACCEPT 
service iptables save
mv /vagrant/tun/server/config/server.conf /etc/openvpn/server.conf
mv /vagrant/tun/keys/static.key /etc/openvpn/static.key
openvpn --config /etc/openvpn/server.conf &
iperf3 -s &


