1.сначала генерируем пару ключей командой ( ssh-keygen -t rsassh-keygen -t rsa )
2.запускаем виртуалку с плэйбуком ( vagrant up && ansible-playbook provision/playbook.yml  ).
3.при желании можно зайти в виртуалку ( vagrant ssh) ,проверить работу (service nginx status).
