В стенде было несколько причин связанных с правами.
1.не правильно выставленные права на папку /etc/named/dynamic/(или я не так сделал- изменил на 777)
С помощью этих прав создаются .jnl и tmp файлы с клиента(nsupdate ... ).
2.нужно установить chmod 644 для /etc/named.conf
3.с помощью утилит audit2why/audit2allow и создаем модули безопасности и применяем их с помощью semodule.
результат проделанной работы хранится в папке logs(скриншоты с логами)
