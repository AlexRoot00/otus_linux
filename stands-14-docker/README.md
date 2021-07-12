
0.1 Все dockerfile's имеют на борту для тестов -curl и lsof.\
1.Dockerfile2 -собирается просто командой docker build -f Dockerfile2 -t ....(в моем случае docker build -f Dockerfile2 -t alexroot/alpine:v0.2.1 .)\
2.Dockerfile имеет все необходимое,но работает черрез docker-compose (команда docker-compose up)\
И так как это все работает:\
докерфайлы при сборке линкуют файлы из ./data/data(1 или 2 -все зависит от того какой докерфайл выбирается).\
В docker-compose.yml\
      - ./data/data1/default2.conf:/etc/nginx/http.d/default.conf \
      - ./data/data1/index.html:/var/www/html/index.html     \
первую строку можно изменить на 
- ./data/data1/default.conf:/etc/nginx/http.d/default.conf\
 ,тогда нужно будет изменить  \
 - ./data/data1/index.html:/var/www/html/index.html \
 и добавить линковку - ./data/:/data\
 на - ./data/data1/index.html:/data/index.html\
 и все будет работать\
 
