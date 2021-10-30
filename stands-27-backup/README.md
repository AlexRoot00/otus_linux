На клиенте генерируем новый командой ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N "" -f rsa и копируем id_rsa.pub на сервер.
Ключ который испозуется тут - инвалидный ,поэтому его меняем его с радостью.
>[vagrant@borgclient ~]$ sudo su
>[borg@borgclient vagrant]$ ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
>и копируем содержимое id_rsa.pub в /borg/.ssh/authorized_keys на сервере и >приводим его в похожий вид：

> [borg@borgserver vagrant]$ cat /home/borg/.ssh/authorized_keys  
> 'command="/usr/local/bin/borg serve" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkaazrHS1h3JQQsg3  
> d2XWP8Y4jUyKgTomCOSzUxE6bycvZffICXKNkcjbeZRqe9CdVbGrrdA6wKxpKH7nQoB7luJNb7SgxKXSfZkUeWp
> BukJ2hshV8UQBxdd4MeGV2UazmDKz1FM16ayGur6oVhoMMeoNnb/6gDRLFutq0fDPGIJTgtyxFNSQBS 
> +y36YjeD4dpXlkLAgycdDTm1QPmrqqFh2JRjGNRN+tszK8taIelUZuUx1onsG5KFgyzmpSlQBHrX5Kf5LMPg25EUbTBrzwlK5g5FCe 
> 8AA0xThEyRe+qGnBsIy7P0EGGQ+ANKWZOQbIwt8+Nu4NIEsskF6W3/ZANdznV2fuyGrNqqIPAy6l6pDJ1 
> R1GEDxiGvunwDiFUfzWS0h1kRgDn6ogEagd0S4aOkL7lHXutce3ucTG3voNvUFliV3KH2WGSD6Xa7ymAqRBAW9gYAkIr60Sxer 
> +AE5BkQJkokHwZVBiizSmWEk9Ak4eczLbpUeP+EKfqaz8= root@borgclient' 
> 
> ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkaazrHS1h3JQQsg3
> d2XWP8Y4jUyKgTomCOSzUxE6bycvZffICXKNkcjbeZRqe9CdVbGrrdA6wKxpKH7nQoB7luJNb7SgxKXSfZkUeWp
> BukJ2hshV8UQBxdd4MeGV2UazmDKz1FM16ayGur6oVhoMMeoNnb/6gDRLFutq0fDPGIJTgtyxFNSQBS
> +y36YjeD4dpXlkLAgycdDTm1QPmrqqFh2JRjGNRN
> +tszK8taIelUZuUx1onsG5KFgyzmpSlQBHrX5Kf5LMPg25EUbTBrzwlK5g5FCe/8AA0xThEyRe+qGnBsIy7P0EGGQ+ANKWZOQbIwt8+Nu4NIEsskF6W3 
> ZANdznV2fuyGrNqqIPAy6l6pDJ1
> R1GEDxiGvunwDiFUfzWS0h1kRgDn6ogEagd0S4aOkL7lHXutce3ucTG3voNvUFliV3KH2WGSD6Xa7ymAqRBAW9gYAkIr60Sxer
> +AE5BkQJkokHwZVBiizSmWEk9Ak4eczLbpUeP+EKfqaz8= root@borgclient
 Далее нам надо инициализировать с клиента репозитории Borg Backup командой /opt/borginit.sh
> запросит создание пароля 
>Enter new passphrase: 
>Enter same passphrase again: 
>Do you want your passphrase to be displayed for verification? [yN]: y
>Your passphrase (between double-quotes): "vagrant"
>Make sure the passphrase displayed above is exactly what you wanted.
> Потом запускаем создание бэкапов с помощью systemctl enable --now borgcreate.timer
> логи создаются при каждом снятии бекапа и их можно посмотреть в /var/log/backup
> Можем посмотреть листинг бэкапа /opt/borglist.sh

 Достать файл из резервной копии можно слeдующей командой
> borg extract borg@borgserver:/var/backup/borgclient::2021-10-30-17:36:13-borgclient etc/hostname
> При запросе :
> Enter passphrase for key /root/.config/borg/keys/borgserver__var_backup_borgclient:
> пишем vagrant(или какой указывали )
> mv etc/hostname /etc/hostname

