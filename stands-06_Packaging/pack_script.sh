yum install -y rpmdevtools  wget gcc pcre* apr* #rpm-build mock mock-rpmfusion-free
wget https://mirror.linux-ia64.org/apache//httpd/httpd-2.4.46.tar.bz2
tar -xvf httpd-2.4.46.tar.bz2 
rm -rf httpd-2.4.46.tar.bz2
cd ./httpd-2.4.46
rpmdev-setuptree