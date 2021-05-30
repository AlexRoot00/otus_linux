yum install epel-release -y;
yum install ssmtp -y;
echo "mailhub=smtp.gmail.com:587" > /etc/ssmtp/ssmtp.conf
echo "UseTLS=YES" >> /etc/ssmtp/ssmtp.conf 
echo "UseSTARTTLS=YES" >> /etc/ssmtp/ssmtp.conf 
#cp /vagrant/bothreceived.sh /opt/
#chmod +x /opt/bothreceived.sh
#echo "/opt/bothreceived.sh " >> .bash_profile
echo "59 * * * * /root/bothreceived.sh " >>  /etc/cron.d/0hourly ;


