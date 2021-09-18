client1 - видит обе зоны, web1 только в зоне dns.lab.\
Проверяем командами host www.newdns.lab, host web1.dns.lab, host web2.dns.lab.\
[vagrant@client1 ~]$ host www.newdns.lab\
client1;\
www.newdns.lab has address 192.168.50.15\
www.newdns.lab has address 192.168.50.16\
[vagrant@client1 ~]$ host web1.dns.lab\
web1.dns.lab has address 192.168.50.15\
[vagrant@client1 ~]$ host web2.dns.lab\
Host web2.dns.lab not found: 3(NXDOMAIN)\
client2:\
[vagrant@client2 ~]$ host www.newdns.lab\
Host www.newdns.lab not found: 3(NXDOMAIN)\
[vagrant@client2 ~]$ host web1.dns.lab\
web1.dns.lab has address 192.168.50.15\
[vagrant@client2 ~]$ host web2.dns.lab\
web2.dns.lab has address 192.168.50.16\
