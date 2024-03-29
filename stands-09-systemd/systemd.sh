yum install -y  epel-release;yum install -y apr spawn-fcgi httpd vim \
java-1.8.0-openjdk.x86_64 wget python3 python39-setuptools;
#install flip 
pip3 install flup
#create logging script
echo '
#!/bin/bash
if [[ ! "$logfile" ]]; then
    echo "Please provide filename" >&2
    exit 1
fi
if [[ ! "$keyword" ]]; then
    echo "Please provide key word" >&2
fi
echo "Searching ${keyword} in ${logfile}"
grep "$keyword" "$logfile"' >> /vagrant/watchlog.sh
chmod +x /vagrant/watchlog.sh
cp /vagrant/watchlog.sh /opt/
#create logging config
echo 'keyword="ALERT"
logfile="/var/log/watchlog.log"' >> /vagrant/watchlog.conf
cp /vagrant/watchlog.conf /etc/sysconfig/
#create logging service
echo '[Unit]
After=network.target
[Service]
EnvironmentFile=/etc/sysconfig/watchlog.conf
WorkingDirectory=/home/vagrant
ExecStart=/bin/bash '/opt/watchlog.sh'
Type=oneshot
[Install]
WantedBy=multi-user.target' >> /vagrant/watchlog.service
cp /vagrant/watchlog.service /etc/systemd/system/
#create timer 
echo '
[Unit]
Description=Run every 30 seconds

[Timer]
OnBootSec=1m
OnUnitActiveSec=30s
Unit=watchlog.service

[Install]
WantedBy=timers.target' >> /vagrant/watchlog.timer
cp /vagrant/watchlog.timer /etc/systemd/system/
#test watchlog log
echo '
ALERT
ALERT
ALERT
ALERT
ALERT
ALERT' >> /vagrant/watchlog.log
cp /vagrant/watchlog.log /var/log/
#starting watch logs
     systemctl daemon-reload
     systemctl enable watchlog.service
     systemctl enable watchlog.timer
     systemctl start watchlog.timer
# create spawn-fcgi.service
echo '[Unit]
Description=spawn-fcgi
After=network.target
[Service]
Type=forking
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
KillMode=process
[Install]
WantedBy=multi-user.target' >> /vagrant/spawn-fcgi.service
cp /vagrant/spawn-fcgi.service /etc/systemd/system/
cp /etc/init.d/spawn-fcgi /vagrant/
rm /etc/init.d/spawn-fcgi
#create dir's fcgi-servers
mkdir /var/www/otustestnet.lan/
cp -r /var/www/html/ /var/www/otustestnet.lan/
mkdir /var/www/otustestnet1.lan/
cp -r /var/www/html/ /var/www/otustestnet1.lan/
#create files fcgi 
echo "#!/usr/bin/python3
from flup.server.fcgi import WSGIServer
from otustestnet.lan import app
if __name__ == '__main__':
    WSGIServer(app).run()" >>/var/www/otustestnet.lan/html/app.fcgi
chmod +x /var/www/otustestnet.lan/html/app.fcgi
chmod 755 /var/www/otustestnet.lan/
echo "#!/usr/bin/python3
from flup.server.fcgi import WSGIServer
from otustestnet1.lan import app
if __name__ == '__main__':
    WSGIServer(app).run()" >>/var/www/otustestnet1.lan/html/app.fcgi
    chmod +x /var/www/otustestnet1.lan/html/app.fcgi
    chmod 755 /var/www/otustestnet1.lan/
#Apache configs create
echo '
LoadModule fastcgi_module /usr/lib64/httpd/modules/mod_fastcgi.so
FastCgiServer /var/www/otustestnet.lan/html/app.fcgi -idle-timeout 300 -processes 2
<VirtualHost *>
    ServerName webapp1.mydomain.com
    DocumentRoot /var/www/otustestnet.lan/html/
    AddHandler fastcgi-script fcgi
    ScriptAlias / /var/www/otustestnet.lan/html/app.fcgi/
    <Location />
        SetHandler fastcgi-script
    </Location>
</VirtualHost>' >> /vagrant/otustestnet.lan.conf
cp /vagrant/otustestnet.lan.conf /etc/httpd/conf.d/
echo '
LoadModule fastcgi_module /usr/lib64/httpd/modules/mod_fastcgi.so
FastCgiServer /var/www/otustestnet.lan/html/app.fcgi -idle-timeout 300 -processes 2
<VirtualHost *>
    ServerName webapp1.mydomain.com
    DocumentRoot /var/www/otustestnet1.lan/html/
    AddHandler fastcgi-script fcgi
    ScriptAlias / /var/www/otustestnet1.lan/html/app.fcgi/
    <Location />
        SetHandler fastcgi-script
    </Location>
</VirtualHost>'>> /vagrant/otustestnet1.lan.conf
cp /vagrant/otustestnet1.lan.conf /etc/httpd/conf.d/
#Apache.service create
echo '[Unit]
Description=The Apache HTTP Server
After=network.target 
[Service]
Type=oneshot
ExecStart=/usr/bin/spawn-fcgi -p 80 /sbin/httpd -f /etc/httpd/conf.d/otustestnet.lan.conf
ExecStart=/usr/bin/spawn-fcgi -p 443 /sbin/httpd -f /etc/httpd/conf.d/otustestnet1.lan.conf
PrivateTmp=True
[Install]
WantedBy=multi-user.target' >> /vagrant/httpd.service
cp /vagrant/httpd.service /etc/systemd/system/
setenforce 0
systemctl start httpd.service
#JIRA create varfie
echo "# install4j response file for Jira Software 8.17.0
app.install.service$Boolean=true
existingInstallationDir=/usr/local/Jira Software
launch.application$Boolean=false
sys.adminRights$Boolean=true
sys.confirmedUpdateInstallationString=false
sys.installationDir=/opt/atlassian/jira
sys.languageId=en">> /vagrant/response.varfile
wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-8.17.0-x64.bin -P /vagrant/
chmod +x /vagrant/atlassian-jira-software-8.17.0-x64.bin
/vagrant/atlassian-jira-software-8.17.0-x64.bin -q -varfile /vagrant/response.varfile
rm /vagrant/response.varfile
rm /etc/init.d/jira
#create jira.service
echo '[Unit]
Description=JIRA
After=network.target
StartLimitIntervalSec=0
[Service]
Type=forking
ExecStart=/opt/atlassian/jira/bin/start-jira.sh
ExecStop=/opt/atlassian/jira/bin/stop-jira.sh
[Install]
WantedBy=multi-user.target' >> /vagrant/jira.service
cp /vagrant/jira.service /etc/systemd/system/
systemctl daemon-reload
#тут все ок,максимум- может зависнуть на активации ,
#во всем виноват /opt/atlassian/jira/jre//bin/java -Djava.util...
#фиксится убийством процесса (например kill 3494(процесс с именем которое выше))
#уточнить в journalctl -xe,потом при запуске все ok(ну +-).
service jira start
pkill -U jira
service jira start
service jira status
