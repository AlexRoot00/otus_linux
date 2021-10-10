[vagrant@master ~]$ mysql -u root -p'iw#kdBq9CMN'   
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 13
Server version: 5.7.35-38-log Percona Server (GPL), Release 38, Revision 3692a61

Copyright (c) 2009-2021 Percona LLC and/or its affiliates
Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> USE bet
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show master status;
+------------------+----------+--------------+------------------+-------------------------------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set                         |
+------------------+----------+--------------+------------------+-------------------------------------------+
| mysql-bin.000002 |   119562 |              |                  | 8d1c698f-29a7-11ec-ad4f-5254004d77d3:1-39 |
+------------------+----------+--------------+------------------+-------------------------------------------+
1 row in set (0.00 sec)

mysql> select * from bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
4 rows in set (0.00 sec)

mysql> insert into bookmaker(id,bookmaker_name) values (255,'this is my test text');
Query OK, 1 row affected (0.00 sec)

mysql> show master status
    -> ;
+------------------+----------+--------------+------------------+-------------------------------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set                         |
+------------------+----------+--------------+------------------+-------------------------------------------+
| mysql-bin.000002 |   119875 |              |                  | 8d1c698f-29a7-11ec-ad4f-5254004d77d3:1-40 |
+------------------+----------+--------------+------------------+-------------------------------------------+
1 row in set (0.00 sec)

mysql> select * from bookmaker;
+-----+----------------------+
| id  | bookmaker_name       |
+-----+----------------------+
|   4 | betway               |
|   5 | bwin                 |
|   6 | ladbrokes            |
| 255 | this is my test text |
|   3 | unibet               |
+-----+----------------------+
5 rows in set (0.00 sec)

mysql> show global variables like 'gtid_executed';
+---------------+-------------------------------------------+
| Variable_name | Value                                     |
+---------------+-------------------------------------------+
| gtid_executed | 8d1c698f-29a7-11ec-ad4f-5254004d77d3:1-40 |
+---------------+-------------------------------------------+
1 row in set (0.00 sec)

посмотрим на репликацию на слэйве:

[vagrant@slave ~]$ mysql -u root -p'iw#kdBq9CMN'
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 16
Server version: 5.7.35-38-log Percona Server (GPL), Release 38, Revision 3692a61

Copyright (c) 2009-2021 Percona LLC and/or its affiliates
Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> USE bet
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from bookmaker
    -> ;
+-----+----------------------+
| id  | bookmaker_name       |
+-----+----------------------+
|   4 | betway               |
|   5 | bwin                 |
|   6 | ladbrokes            |
| 255 | this is my test text |
|   3 | unibet               |
+-----+----------------------+
5 rows in set (0.00 sec)

mysql> show global variables like 'gtid_executed';
+---------------+-------------------------------------------+
| Variable_name | Value                                     |
+---------------+-------------------------------------------+
| gtid_executed | c2d7f140-29ad-11ec-a484-5254004d77d3:1-40 |
+---------------+-------------------------------------------+
1 row in set (0.00 sec)

mysql> show global variables like 'gtid_purged';
+---------------+-------------------------------------------+
| Variable_name | Value                                     |
+---------------+-------------------------------------------+
| gtid_purged   | c2d7f140-29ad-11ec-a484-5254004d77d3:1-39 |
+---------------+-------------------------------------------+
1 row in set (0.00 sec)

[root@slave vagrant]# mysqlbinlog /var/lib/mysql/mysql-bin.000001 
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#211010 19:40:12 server id 2  end_log_pos 123 CRC32 0xa1a84aa9  Start: binlog v 4, server v 5.7.35-38-log created 211010 19:40:12 at startup
# Warning: this binlog is either in use or was not closed properly.
ROLLBACK/*!*/;
BINLOG '
/LRiYQ8CAAAAdwAAAHsAAAABAAQANS43LjM1LTM4LWxvZwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAD8tGJhEzgNAAgAEgAEBAQEEgAAXwAEGggAAAAICAgCAAAACgoKKioAEjQA
AalKqKE=
'/*!*/;
# at 123
#211010 19:40:12 server id 2  end_log_pos 154 CRC32 0xab52ca3c  Previous-GTIDs
# [empty]
# at 154
#211010 20:00:33 server id 1  end_log_pos 219 CRC32 0x729baa5c  GTID    last_committed=0  sequence_number=1        rbr_only=no
SET @@SESSION.GTID_NEXT= 'c2d7f140-29ad-11ec-a484-5254004d77d3:40'/*!*/;
# at 219
#211010 20:00:33 server id 1  end_log_pos 292 CRC32 0xe2374d52  Query   thread_id=10    exec_time=0        error_code=0
SET TIMESTAMP=1633860033/*!*/;
SET @@session.pseudo_thread_id=10/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=0, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=1436549152/*!*/;
SET @@session.auto_increment_increment=1, @@session.auto_increment_offset=1/*!*/;
/*!\C utf8 *//*!*/;
SET @@session.character_set_client=33,@@session.collation_connection=33,@@session.collation_server=8/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
BEGIN
/*!*/;
# at 292
#211010 20:00:33 server id 1  end_log_pos 436 CRC32 0xce33e5f6  Query   thread_id=10    exec_time=0        error_code=0
use `bet`/*!*/;
SET TIMESTAMP=1633860033/*!*/;
insert into bookmaker(id,bookmaker_name) values (255,'this is my test text')
/*!*/;
# at 436
#211010 20:00:33 server id 1  end_log_pos 467 CRC32 0x6490d678  Xid = 398
COMMIT/*!*/;
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
[root@slave vagrant]# 

