По переходу по  адресу 127.0.0.1:1234(Для этого был сделан проброс box.vm.network "forwarded_port", \
guest: 8080, host: 1234, host_ip: "127.0.0.1", id: "nginx" (в Vagrantfile ) \
то мы попадаем на виртуальную машину inetRouter2 на 8080. Затем правилами iptables мы управляем пакетами,
которые пришли на порт 8080 интерфейса eth0 и отправляем их по адресу 192.168.0.2:80. \
Исходя из правил маршрутизации компьютер знает куда отправлять дальше данные пакеты, \
и он их отправляет на 192.168.255.3 (centralRouter), \
далее они попадают на веб-сервер 192.168.0.2 на порт 80 после чего возвращаются отправителю обратно в той же последовательности: \
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 192.168.0.2:80 \
sudo iptables -t nat -A POSTROUTING --destination 192.168.0.2/32 -j SNAT --to-source 192.168.255.2 \
Для работы port knocking'a было установлен пакет knock-server-0.7-2.el7.nux.x86_64.rpm . \
и был отредактирован конфиг(/etc/sysconfig/knockd): 
[options] \
	UseSyslog \

[opencloseSSH] \
	sequence      = 2222:tcp,3333:tcp,4444:tcp \
	seq_timeout   = 15 \
	tcpflags      = syn \
	start_command = /sbin/iptables -I INPUT 1 -s %IP% -p tcp --dport 22 -j ACCEPT \
	cmd_timeout   = 30 \
	stop_command  = /sbin/iptables -D INPUT -s %IP% -p tcp --dport ssh -j ACCEPT \

и /etc/sysconfig/knockd: \
OPTIONS="-i eth1" \

теперь можно проверить настройку knocking port. \
Необходимо зайти на centralRouter командой vagrant ssh centralRouter и выполнить: \
for x in 2222 3333 4444; do sudo nmap -Pn --host_timeout 100 --max-retries 0 -p $x 192.168.255.1; done \
Здесь программа nmap перебирает в цикле порты по определенной последовательности. \

Также можно установить на centalRouter программу knock и выполнить сдедующую команду  \
knock 192.168.4.24 2222 3333 4444 -d 500, где d это delay 500 мс между портами. \
Все гостевые машины по умолчанию ходят в интернет через 192.168.255.1 (inetRouter), для этого сделаны настройки (на примере centralServer): \
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0  \
echo "GATEWAY=192.168.0.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1 \
Т.е. мы выключаем маршрут по умолчанию для интерфейса eth0 (10.0.2.15 - это сеть по умолчанию виртуалбокса) и \
прописываем шлюз по умолчанию для другого интерфейса, который смотрит в centralRouter. 
