#!/bin/bash 

# by yeweijie
# 2017-06-12

# centos7初始化脚本，关闭防火墙以及更新本地镜像源

# 0: 初始化环境
# 关闭防火墙、selinux、更新本地镜像配置

systemctl  stop  firewalld.service
systemctl  disable  firewalld.service

setenforce   0 
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g"  /etc/selinux/config


cd /etc/yum.repos.d/
mkdir bak
mv CentOS-*.repo bak/ 
wget http://192.168.6.184/local-yum/Richstone_local_yum_Centos_7.repo
wget http://192.168.6.184/local-yum/Richstone_local_epel_Centos_7.repo
wget http://192.168.6.184/local-yum/Richstone_local_qemu-ev_Centos_7.repo
wget http://192.168.6.184/local-yum/Richstone_local_rdo-release_Centos_7.repo


yum clean all 
yum makecache 
sleep 5 

# 1: 配置python环境

mkdir -p ~/.pip          # 使用豆瓣pip源
#vim ~/.pip/pip.conf
echo -e "[global]\n" >> ~/.pip/pip.conf
# 清华的源比豆瓣的源快很多
echo -e "index-url = https://pypi.tuna.tsinghua.edu.cn/simple/   \n " >> ~/.pip/pip.conf
yum -y  install  python-pip
pip install --upgrade pip


# 2: 获取文件包：
yum install -y screen 
yum install -y git  # 安装git

sleep 3 


# 3： 配置基础环境
# 3.1： ntp 
yum -y  install ntp
systemctl  start  ntpd.service
systemctl  enable  ntpd.service


echo "init successfully"

