apt upgrade -y;
apt install -y python3 docker*;

echo "create users"
sudo useradd -G ssh -s /bin/bash user ;
sudo useradd -G ssh,docker -s /bin/bash duser ;
sudo useradd -G ssh,root -s /bin/bash admin ;
#echo "password" #unworking =(
#echo otususer | passwd user &&
#echo otususer | passwd duser  &&
#echo otususer | passwd admin  &&
#echo "otususer" | passwd -e user  &&
#echo "otususer" | passwd -e duser &&
#echo "otususer" | passwd -e admin &&
#echo "create sudoers.d/"
sudo touch /etc/sudoers.d/user;
cat >>/etc/sudoers.d/user <<EOF
EOF
sudo touch /etc/sudoers.d/duser;
sudo cat >>/etc/sudoers.d/duser <<EOF
duser ALL=(ALL) NOPASSWD:ALL
EOF


sudo touch /etc/sudoers.d/admin;
sudo cat >>/etc/sudoers.d/admin <<EOF
admin ALL=(ALL) NOPASSWD:ALL
EOF

echo "password" #unworking =(
sudo echo OtusUser | passwd -e user  &&
sudo echo OtusDuser | passwd -e duser &&  
sudo echo OtusAdmin | passwd -e admin &&
sudo echo "chmod 0640 /etc/shadow" && 
sudo chmod 0640 /etc/shadow &&
echo "time.conf"
sudo touch /etc/sudoers.d/user;
sudo cat >>/etc/sudoers.d/user <<EOF
user ALL=(ALL) NOPASSWD:ALL
EOF
sudo cat >>/etc/security/time.conf <<EOF
*;*;user;Wd0800-2000
*;*;duser;!Wd0800-2000
*;*;admin;Al
EOF
sudo awk '{gsub(/pam_nologin.so/,"pam_time.so")}1'  /etc/pam.d/sshd
#echo "sshd + time.so" &&
#sudo cat >> /etc/pam.d/sshd <<EOF
#account required pam_time.so
#EOF
echo "restart ssh " ;
#sudo awk '{gsub(/#IgnoreUserKnownHosts no/,IgnoreUserKnownHosts yes")}1' /etc/ssh/sshd_config &&
#sudo awk '{gsub(/PasswordAuthentication no/,PasswordAuthentication yes")}1' /etc/ssh/sshd_config &&
sudo systemctl restart sshd.service 
#rm -rf /etc/ssh/sshd_config
touch sshd_conf;
cat >>sshd_conf<<EOF
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
IgnoreUserKnownHosts yes

PasswordAuthentication yes

ChallengeResponseAuthentication yes

UsePAM yes
X11Forwarding no
PrintMotd no

Subsystem       sftp    /usr/lib/openssh/sftp-server

ClientAliveInterval 120
AllowUsers admin duser user
# debian vagrant box speedup
UseDNS no
EOF
chmod 0744 sshd_conf
cp -rf ./sshd_conf /etc/ssh/
sudo cat /etc/ssh/sshd_config
sudo service sshd reload