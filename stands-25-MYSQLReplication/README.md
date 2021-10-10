После поднятия виртуальных машин, выполним операции на мастере:

[vagrant@master ~]$ mysql -u root -p'iw#kdBq9CMN' \
mysql> USE bet  \
Reading table information for completion of table and column names \
You can turn off this feature to get a quicker startup with -A \
------------- 
Database changed \
mysql> show master status;\
|+------------------+----------+--------------+------------------+-------------------------------------------+\
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set                         |\
+------------------+----------+--------------+------------------+-------------------------------------------+\
| mysql-bin.000002 |   119562 |              |                  | 8d1c698f-29a7-11ec-ad4f-5254004d77d3:1-39 |\
+------------------+----------+--------------+------------------+-------------------------------------------+\
1 row in set (0.00 sec) 

mysql> select * from bookmaker;  \
+----+----------------+\
| id | bookmaker_name | \
+----+----------------+  \
|  4 | betway         |  \
|  5 | bwin           |  \
|  6 | ladbrokes      |  \
|  3 | unibet         |  \
+----+----------------+  \
4 rows in set (0.00 sec) \

mysql> insert into bookmaker(id,bookmaker_name) values (255,'this is my test text');
Query OK, 1 row affected (0.00 sec)

mysql> show master status;

+------------------+----------+--------------+------------------+-------------------------------------------+\
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set                         |\
+------------------+----------+--------------+------------------+-------------------------------------------+\
| mysql-bin.000002 |   119875 |              |                  | 8d1c698f-29a7-11ec-ad4f-5254004d77d3:1-40 |\
+------------------+----------+--------------+------------------+-------------------------------------------+\
1 row in set (0.00 sec)\

mysql> select * from bookmaker;\
+-----+----------------------+\
| id  | bookmaker_name       |\
+-----+----------------------+\
|   4 | betway               |\
|   5 | bwin                 |\
|   6 | ladbrokes            |\
| 255 | this is my test text |\
|   3 | unibet               |\
+-----+----------------------+\
5 rows in set (0.00 sec) \

mysql> show global variables like 'gtid_executed'; \
+---------------+-------------------------------------------+\
| Variable_name | Value                                     |\
+---------------+-------------------------------------------+\
| gtid_executed | 8d1c698f-29a7-11ec-ad4f-5254004d77d3:1-40 |\
+---------------+-------------------------------------------+\
1 row in set (0.00 sec)\

посмотрим на репликацию на слэйве:\

[vagrant@slave ~]$ mysql -u root -p'iw#kdBq9CMN'\
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql> USE bet
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from bookmaker;\

+-----|-----------------------------+\
| id  | bookmaker_name :---: |\
|-----+-----------------------------+\
| :::4| betway :-----------------:    |\
| :::5| bwin   :---------------------:              |\
| :::6| ladbrokes :---------------:|\
| 255 | this is my test text --: |\
|:::: 3 | unibet :-----------------: |\
+-----+----------------------------+\
5 rows in set (0.00 sec)\

mysql> show global variables like 'gtid_executed';\

+---------------+-------------------------------------------+\
| Variable_name | Value :---------------------------:       |\
+---------------+-------------------------------------------+\
| gtid_executed | c2d7f140-29ad-11ec-a484-5254004d77d3:1-40 |\
+---------------+-------------------------------------------+\
1 row in set (0.00 sec) 

mysql> show global variables like 'gtid_purged';\
+--------------------+---------------------------------------------------------------+\
| Variable_name | Value  :----------------------------------------------------:      |\
+--------------------+---------------------------------------------------------------+\
| gtid_purged  :-: | c2d7f140-29ad-11ec-a484-5254004d77d3:1-39                       |\
+--------------------+---------------------------------------------------------------+\
1 row in set (0.00 sec)\

[root@slave vagrant]# mysqlbinlog /var/lib/mysql/mysql-bin.000001 \

#211010 20:00:33 server id 1  end_log_pos 436 CRC32 0xce33e5f6  Query   thread_id=10    exec_time=0        error_code=0\
use `bet`/*!*/; \
SET TIMESTAMP=1633860033/*!*/; \
insert into bookmaker(id,bookmaker_name) values (255,'this is my test text')\
/*!*/;\
# at 436 \
#211010 20:00:33 server id 1  end_log_pos 467 CRC32 0x6490d678  Xid = 398\
COMMIT/*!*/;\
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;\
DELIMITER ;\
# End of log file\
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;\
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;\
[root@slave vagrant]# \

