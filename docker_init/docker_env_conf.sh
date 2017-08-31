#!/bin/bash 

# by yeweijie
# 2017-07-18

# 本脚本用于CentOS6 配置docker初始化脚本



mkdir /opt/docker_env
DIR=/opt/docker_env


cd  $DIR
wget http://192.168.6.184/docker_init/kernel-ml-aufs-3.10.5-3.el6.x86_64.rpm
wget http://192.168.6.184/docker_init/kernel-ml-aufs-devel-3.10.5-3.el6.x86_64.rpm
rpm -ivh kernel-ml-aufs-3.10.5-3.el6.x86_64.rpm kernel-ml-aufs-devel-3.10.5-3.el6.x86_64.rpm 


# 升级内核后，修改相关配置
sed -i "s/default=1/default=0/g"  /boot/grub/grub.conf

#/etc/grub.conf 

more /etc/grub.conf |grep default
sleep 3


# 配置docker yum环境

cd /etc/yum.repos.d/
wget http://192.168.6.184/local-yum/Richstone_local_docker_CentOS_6.repo

yum makecache

yum repolist |grep docker
sleep 3


# 重启后生效

echo "重启后生效:请执行reboot "
sleep 3 

重启后执行以下命令：

#yum -y install docker-io
#service docker start
#chkconfig docker on

