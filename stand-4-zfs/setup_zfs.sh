#!/bin/bash

yum install -y yum-utils

sudo yum -y install http://download.zfsonlinux.org/epel/zfs-release.el8_2.noarch.rpm
gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
yum-config-manager --enable zfs-kmod
yum-config-manager --disable zfs
yum install -y zfs wget
modprobe zfs
zpool create tank /dev/sdb /dev/sdc ; 
zpool create testmi mirror /dev/sdd /dev/sde mirror /dev/sdf /dev/sdg
zfs create tank/userdir1 ;cd /tank/userdir1/;curl -o "War_and_Peace.txt" -J -L https://www.gutenberg.org/cache/epub/2600/pg2600.txt; zfs set compression=lzjb tank/userdir1;
zfs create tank/userdir2 ;cd /tank/userdir2/;curl -o "War_and_Peace.txt" -J -L https://www.gutenberg.org/cache/epub/2600/pg2600.txt; zfs set compression=lz4 tank/userdir2;
zfs create tank/userdir3 ;cd /tank/userdir3/;curl -o "War_and_Peace.txt" -J -L https://www.gutenberg.org/cache/epub/2600/pg2600.txt; zfs set compression=gzip tank/userdir3;
zfs create tank/userdir4 ; cd /tank/userdir4/;curl -o "War_and_Peace.txt" -J -L https://www.gutenberg.org/cache/epub/2600/pg2600.txt; zfs set compression=gzip-9 tank/userdir4;
zfs create testmi/userdir1 ;cd /testmi/userdir1/;curl -o "War_and_Peace.txt" -J -L https://www.gutenberg.org/cache/epub/2600/pg2600.txt; zfs set compression=lzjb testmi/userdir1;
zfs create testmi/userdir2 ;cd /testmi/userdir2/;curl -o "War_and_Peace.txt" -J -L https://www.gutenberg.org/cache/epub/2600/pg2600.txt; zfs set compression=lz4 testmi/userdir2;
zfs create testmi/userdir3 ;cd /testmi/userdir3/;curl -o "War_and_Peace.txt" -J -L https://www.gutenberg.org/cache/epub/2600/pg2600.txt; zfs set compression=gzip testmi/userdir3;
zfs create testmi/userdir4 ;cd /testmi/userdir4/;curl -o "War_and_Peace.txt" -J -L https://www.gutenberg.org/cache/epub/2600/pg2600.txt; zfs set compression=gzip-9 testmi/userdir4;
zfs list -S used;
tar -zxvf zfs_task1.tar.gz;
cd zpoolexport; zpool import -d filea -d fileb otus;
zpool status -v;
zfs list -o recordsize; # /otus or /tank or/testmi
zfs list -o compression;# /otus or /tank or/testmi
zfs list -o checksum;   # /otus or /tank or/testmi
cd .. ; zfs receive tank/otusdata < otus_task2.file
cat /tank/otusdata/task1/file_mess/secret_message
# https://github.com/sindresorhus/awesome
