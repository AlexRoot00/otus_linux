#!/usr/bin/env bash
password=$(cat /var/log/mysqld.log | grep 'root@localhost:' | awk '{print $11}')

echo -e "[client]\n\ruser=\"root\"\n\rpassword=\"$password\"" > /home/vagrant/my.cnf
id=1
mysql --defaults-file=/home/vagrant/my.cnf  -e "ALTER USER USER() IDENTIFIED BY 'iw#kdBq9CMN';" --connect-expired-password
if [ $? -eq 0 ]; then  id=0; fi
password='iw#kdBq9CMN'
echo -e  "[client]\n\ruser=\"root\"\n\rpassword=\"$password\"" > /home/vagrant/my.cnf
if [ $id -eq 0 ]; then  mysql --defaults-file=/home/vagrant/my.cnf -e "CREATE DATABASE bet;";
mysql --defaults-file=/home/vagrant/my.cnf -D bet < /vagrant/files/bet.dmp;
mysql --defaults-file=/home/vagrant/my.cnf  -e  "CREATE USER 'repl'@'%' IDENTIFIED BY '!OtusLinux2021';";
mysql --defaults-file=/home/vagrant/my.cnf  -e  "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY '!OtusLinux2021';";
mysqldump  --defaults-file=/home/vagrant/my.cnf --all-databases --triggers --routines --master-data --ignore-table=bet.events_on_demand --ignore-table=bet.v_same_event  > /home/vagrant/master.sql; fi
