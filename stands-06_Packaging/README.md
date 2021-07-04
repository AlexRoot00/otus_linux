Будем собирать nginx с поддержкой openssl.\
Для создания своего rpm пакета.НУжно установить инструментарий.\
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils vim gcc &&
yum install -y openssl-devel \
заходим в директорию,где будет собираться пакет\
В данном случае будет собираться от рута\
cd /root/   \
скачиваем и распаковываем пакеты с которыми будем работать \
wget https://nginx.org/packages/centos/8/SRPMS/nginx-1.20.1-1.el8.ngx.src.rpm && \
wget https://www.openssl.org/source/latest.tar.gz && \
tar -xvf latest.tar.gz &&  
rpm -i nginx-1.20.1-1.el8.ngx.src.rpm &&
так же нужно будет добавить строчку  \
    --with-openssl=/root/openssl-1.1.1k \
в ./rpmbuild/SPECS/nginx.spec \
(в данном случае скопируем спеку) \
cp /vagrant/SPECS/nginx.spec ./rpmbuild/SPECS/  \
собираем и устанавливаем зависимости  \
yum-builddep ./rpmbuild/SPECS/nginx.spec -y  \
rpmbuild -bb ./rpmbuild/SPECS/nginx.spec  \
устанавливаем и проверяем работоспособность  \
yum install -y rpmbuild/RPMS/x86_64/nginx-1.20.1-1.el8.ngx.x86_64.rpm  \
systemctl start nginx  \
systemctl status nginx  \
