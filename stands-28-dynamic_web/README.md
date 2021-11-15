=========Stands-28: DynamicWeb .===================\
proxy server: nginx \
service---------|internal|external|Context \
-----------------|--ports-|-ports--|--Type--- \
goservice:------|--9091--|--81----|plain/json \
flaskservice:----|--9092--|--82----|plain/json \
nodejs service: |--3000--|--80----|plain/text 

========Output:=================== \
>curl 'http://192.168.12.10:80' \
Hello World \
>curl 'http://192.168.12.10:81' \
{"message":"go_pong"} \
>curl 'http://192.168.12.10:82' \
{"message":"py_ok"} \

=======Как проверить работоспособность:============ 
Можно перейти по ссылкам: \
>>http://192.168.12.10:80 \
>>http://192.168.12.10:81 \
>>http://192.168.12.10:82 
