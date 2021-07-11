yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils vim gcc &&
yum install -y openssl-devel && 
cd /root/
wget https://nginx.org/packages/centos/8/SRPMS/nginx-1.20.1-1.el8.ngx.src.rpm &&
wget https://www.openssl.org/source/latest.tar.gz &&
tar -xvf latest.tar.gz &&
rpm -i nginx-1.20.1-1.el8.ngx.src.rpm &&
cp /vagrant/SPECS/nginx.spec ./rpmbuild/SPECS/
yum-builddep ./rpmbuild/SPECS/nginx.spec -y
rpmbuild -bb ./rpmbuild/SPECS/nginx.spec
yum install -y rpmbuild/RPMS/x86_64/nginx-1.20.1-1.el8.ngx.x86_64.rpm 
cat >>default.conf <<EOF
server {
    listen       80;
    server_name  localhost;
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        autoindex on;
    }
}
EOF
cp default.conf /etc/nginx/conf.d/
mkdir /usr/share/nginx/html/repo

cat >> otus.repo <<EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
cp otus.repo /etc/yum.repos.d/
sudo systemctl start nginx 
sudo systemctl status nginx

cp rpmbuild/RPMS/x86_64/nginx-1.20.1-1.el8.ngx.x86_64.rpm /usr/share/nginx/html/repo/
createrepo /usr/share/nginx/html/repo/
yum list | grep otus
