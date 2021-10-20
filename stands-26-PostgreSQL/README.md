Команда vagrant up поднимает 3 сервера - master, slave и backup, также запускает ansible-playbook. Для проверки - выполнить последовательно команды.

Вход на master

vagrant ssh master

Далее под пользователем postgres создадим БД testbd, чтобы на её примере проверить репликацию на slave.
vagrant ssh master
[vagrant@master ~]$ sudo su
[root@master vagrant]# su - postgres
[postgres@master ~]$ psql
psql (11.13)
Type "help" for help.


postgres=# create database testdb;
CREATE DATABASE
postgres=# exit
[postgres@master ~]$ exit
logout
[root@master vagrant]# exit
exit
[vagrant@master ~]$ exit
logout
Connection to 127.0.0.1 closed.

vagrant ssh slave
[vagrant@slave ~]$ sudo su
[root@slave vagrant]# su - postgres
[postgres@slave ~]$ psql
psql (11.13)\
Type "help" for help.

postgres=# \l  
смотрим вывод в skrin.png

postgres=# exit
[postgres@slave ~]$ exit
logout
[root@slave vagrant]# exit
exit
[vagrant@slave ~]$ exit
logout
Connection to 127.0.0.1 closed.

vagrant ssh backup  
[vagrant@backup ~]$ sudo su
[root@backup vagrant]# barman check master
Server master:
        PostgreSQL: OK
        superuser or standard user with backup privileges: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (no last_backup_maximum_age provided)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: OK (have 0 backups, expected at least 0)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        systemid coherence: OK (no system Id stored on disk)
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archive_mode: OK
        archive_command: OK
        archiver errors: OK
[root@backup vagrant]# barman replication-status master
Status of streaming clients for server 'master':
  Current LSN on master: 0/4000060
  Number of streaming clients: 2

  1. Async standby
     Application name: walreceiver
     Sync stage      : 5/5 Hot standby (max)
     Communication   : TCP/IP
     IP Address      : 192.168.1.20 / Port: 41052 / Host: -
     User name       : streaming_user
     Current state   : streaming (async)
     Replication slot: standby_slot
     WAL sender PID  : 26264
     Started at      : 2021-10-18 10:55:58.756285+00:00
     Sent LSN   : 0/4000060 (diff: 0 B)
     Write LSN  : 0/4000060 (diff: 0 B)
     Flush LSN  : 0/4000060 (diff: 0 B)
     Replay LSN : 0/4000060 (diff: 0 B)

  2. Async WAL streamer
     Application name: barman_receive_wal
     Sync stage      : 3/3 Remote write
     Communication   : TCP/IP
     IP Address      : 192.168.1.30 / Port: 43486 / Host: -
     User name       : barman_streaming_user
     Current state   : streaming (async)
     Replication slot: barman
     WAL sender PID  : 26506
     Started at      : 2021-10-18 11:02:02.400047+00:00
     Sent LSN   : 0/4000060 (diff: 0 B)
     Write LSN  : 0/4000060 (diff: 0 B)
     Flush LSN  : 0/4000000 (diff: -96 B)

