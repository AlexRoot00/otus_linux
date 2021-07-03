yum upgrade -y;
yum install -y python3 python3-dnf ;
sudo useradd user1 ;
sudo useradd duser2 ;
sudo useradd admin ;
echo "otususer" | sudo passwd --stdin user1  ;
echo "otususer" | sudo passwd --stdin duser2 ;
echo "otususer" | sudo passwd --stdin admin  ;
bash -c "sed -i
's/^PasswordAuthentication.*$/PasswordAuthentication yes/'/etc/ssh/sshd_config && systemctl restart sshd.service"
