#!/bin/bash
email_tran=
email_rec=
password=
recfile=logs.txt
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'  /vagrant/access-4560-644067.log > logs.txt

ssmtp -au $email_rec -ap $password $email_tran < logs.txt

