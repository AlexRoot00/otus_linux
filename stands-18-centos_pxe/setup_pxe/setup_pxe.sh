#!/bin/bash

echo Install PXE server
yum -y install epel-release

yum -y install dhcp-server
yum -y install tftp-server
yum -y install nfs-utils
firewall-cmd --add-service=tftp
# disable selinux or permissive
setenforce 0
# 

centos_version=8.3.2011

cat >/etc/dhcp/dhcpd.conf <<EOF
option space pxelinux;
option pxelinux.magic code 208 = string;
option pxelinux.configfile code 209 = text;
option pxelinux.pathprefix code 210 = text;
option pxelinux.reboottime code 211 = unsigned integer 32;
option architecture-type code 93 = unsigned integer 16;
subnet 10.0.0.0 netmask 255.255.255.0 {
	#option routers 10.0.0.254;
	range 10.0.0.100 10.0.0.120;
	class "pxeclients" {
	  match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";
	  next-server 10.0.0.20;
	  if option architecture-type = 00:07 {
	    filename "uefi/shim.efi";
	    } else {
	    filename "pxelinux/pxelinux.0";
	  }
	}
}
EOF
systemctl start dhcpd
systemctl enable dhcpd

systemctl start tftp.service
systemctl enable tftp.service
yum -y install syslinux-tftpboot.noarch
mkdir /var/lib/tftpboot/pxelinux
cp /tftpboot/pxelinux.0 /var/lib/tftpboot/pxelinux
cp /tftpboot/libutil.c32 /var/lib/tftpboot/pxelinux
cp /tftpboot/menu.c32 /var/lib/tftpboot/pxelinux
cp /tftpboot/libmenu.c32 /var/lib/tftpboot/pxelinux
cp /tftpboot/ldlinux.c32 /var/lib/tftpboot/pxelinux
cp /tftpboot/vesamenu.c32 /var/lib/tftpboot/pxelinux

mkdir /var/lib/tftpboot/pxelinux/pxelinux.cfg

cat >/var/lib/tftpboot/pxelinux/pxelinux.cfg/default <<EOF
default menu
prompt 0
timeout 600
MENU TITLE Demo PXE setup
LABEL linux-auto
  menu label ^Auto install system
    menu default
  kernel images/CentOS-8/vmlinuz
  append initrd=images/CentOS-8/initrd.img ip=enp0s3:dhcp inst.ks=nfs:10.0.0.20:/home/vagrant/cfg/ks.cfg inst.repo=nfs:10.0.0.20:/mnt/centos8-autoinstall
LABEL vesa
  menu label Install system with ^basic video driver
  kernel images/CentOS-8/vmlinuz
  append initrd=images/CentOS-8/initrd.img ip=dhcp inst.xdriver=vesa nomodeset
LABEL rescue
  menu label ^Rescue installed system
  kernel images/CentOS-8/vmlinuz
  append initrd=images/CentOS-8/initrd.img rescue
LABEL local
  menu label Boot from ^local drive
  localboot 0xffff
EOF

mkdir -p /var/lib/tftpboot/pxelinux/images/CentOS-8/
curl -O http://ftp.mgts.by/pub/CentOS/$centos_version/BaseOS/x86_64/os/images/pxeboot/initrd.img
curl -O http://ftp.mgts.by/pub/CentOS/$centos_version/BaseOS/x86_64/os/images/pxeboot/vmlinuz
cp {vmlinuz,initrd.img} /var/lib/tftpboot/pxelinux/images/CentOS-8/

systemctl start nfs-server.service


autoinstall(){
  # to speedup replace URL with closest mirror
  curl -O http://ftp.mgts.by/pub/CentOS/$centos_version/BaseOS/x86_64/os/images/boot.iso
  mkdir /mnt/centos8-autoinstall
  mount -t iso9660 boot.iso /mnt/centos8-autoinstall
  echo '/mnt/centos8-autoinstall *(ro)' >> /etc/exports
  mkdir /home/vagrant/cfg
cat > /home/vagrant/cfg/ks.cfg <<EOF
#version=RHEL8
ignoredisk --only-use=sda
autopart --type=lvm
# Partition clearing information
clearpart --all --initlabel --drives=sda
# Use graphical install
text
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8
#repo
url --url="https://mirror.yandex.ru/centos/8/BaseOS/x86_64/os/" 

# Network information
network  --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate
network  --bootproto=dhcp --device=enp0s8 --onboot=off --ipv6=auto --activate
network  --hostname=test.localdomain
# Root password
rootpw --plaintext Vagrant
# Run the Setup Agent on first boot
firstboot --enable
# Do not configure the X Window System
skipx
# System services
services --enabled="chronyd"
# System timezone
timezone Asia/Vladivostok --isUtc
user --groups=wheel --name=vagrant --password=Vagrant --plaintext --gecos="Vagrant"
%packages
@^minimal-environment
kexec-tools
vim
wget
yum-utils
net-tools
nfs-utils
firewalld
%end
%addon com_redhat_kdump --enable --reserve-mb='auto'
%end
%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
EOF
echo '/home/vagrant/cfg *(ro)' >> /etc/exports
  systemctl reload nfs-server.service
}
# uncomment to enable automatic installation
autoinstall