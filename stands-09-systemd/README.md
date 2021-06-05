Возникает проблема: запустится jira или нет, сразу после создания виртуальной машины - русская рулетка.
Если он не запускается, то вам нужно будет войти в виртуальную машину и запустить service start jira от root.
Брандмауэр и selinux - не настроены. Запуск службы httpd - создает pid, но статус мертв.
Не могу сказать почему. Возможно, причина в управлении через fastcgi. 




There is a problem : will jira start or not, immediately after the virtual machine is created - russian roulette.
If it does not start, then you will need to enter the virtual machine and start service start jira from root.
Firewall and selinux - not configured. Service start httpd - creates pids, but the status is dead. I can't say why.
The may be reason is control via fastcgi.
