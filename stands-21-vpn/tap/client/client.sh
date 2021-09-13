yum install -y epel-release
yum install -y openvpn iperf3 iptables-services
setenforce 0
systemctl enable iptables
systemctl start iptables;
sed -i 's/=enforcing/=disabled/g' /etc/selinux/config
echo "1"
mv /vagrant/tap/client/config/client.conf /etc/openvpn/client.conf
echo "11"
mv /vagrant/tap/keys/static.key /etc/openvpn/static.key
echo "111"
openvpn --config /etc/openvpn/client.conf &
echo "1111"
echo "11111"
iperf3 -c 10.11.12.1 -t 40 -i 5 >> statistic.log &
