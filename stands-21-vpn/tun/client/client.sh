yum install -y epel-release
yum install -y openvpn iperf3
setenforce 0
echo "1"
mv /vagrant/tun/client/config/client.conf /etc/openvpn/client.conf
echo "11"
mv /vagrant/tun/keys/static.key /etc/openvpn/static.key
echo "111"
openvpn --config /etc/openvpn/client.conf 
echo "1111"
echo "11111"
iperf3 -c 10.11.13.1 -t 40 -i 5 >> statistic.log &
