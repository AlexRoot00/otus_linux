Для отправки логов нужно будет отредактировать строчки в bash_conf.sh
#эти настройки приведены в части примера.И их надо настроить под почту отправителя. 
#echo "mailhub=smtp.gmail.com:465" > /etc/ssmtp/ssmtp.conf
#echo "UseTLS=YES" >> /etc/ssmtp/ssmtp.conf 
#echo "UseSTARTTLS=YES" >> /etc/ssmtp/ssmtp.conf

в bothreceived отредактировать эти строчки:
почта принимающего
email_tran=
почта отпрвителя
email_rec=
пароль от электронного ящика отправителя
password=

Должна заработать отправка,если нет,то буду смотреть .