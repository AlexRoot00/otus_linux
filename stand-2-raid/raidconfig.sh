yum install -y epel-release mdadm  smartmontools elfutils-libelf-devel hdparm gdisk  &&
sudo su  &&
lsblk && ls /dev/sd* &&
bash /vagrant/raidconf.sh
