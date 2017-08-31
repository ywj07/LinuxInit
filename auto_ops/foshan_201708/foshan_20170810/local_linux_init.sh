#!/bin/bash 

# by yeweijie
# 2017-08-09
# 本脚本用于刚安装完系统的CentOS 6的操作系统进行一些初始化工作：具体如下
# 0:关闭防火墙以及selinux
# 1:修改本地yum配置
# 2:添加epel源配置，本地镜像服务器
# 4:安装网络监控工具：iftop
# 5:安装screen工具
# 6:安装系统监控工具 glances
# 7:ssh登陆之忽略known_hosts文件


DIR=/home/linux_init_1
mkdir  $DIR
cd  $DIR

# 0:关闭防火墙以及selinux
service iptables stop
chkconfig iptables off
echo -e  "/sbin/service  iptables stop \n" >> /etc/rc.d/rc.local 


setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/"   /etc/selinux/config


# 1:修改本地yum配置
cd $DIR
wget  http://192.168.5.109/local-yum/update-yum.sh
chmod +x update-yum.sh  &&  bash  update-yum.sh
sleep 5

# 2:添加epel源配置，本地镜像服务器
# yum -y install epel-release
sleep 3 
cd  /etc/yum.repos.d
wget http://192.168.5.109/local-yum/Richstone_local_epel_Centos_6.repo
yum clean all
yum makecache


# 4:安装网络监控工具 iftop 
echo -e  "安装网络监控工具 iftop\n"
#cd $DIR
yum -y install  iftop

# 5:安装screen工具
yum -y install screen 
sleep 5

# 6:安装系统监控工具 glances
yum -y install  glances
sleep 5 

# 7:ssh登陆之忽略known_hosts文件
echo "StrictHostKeyChecking no"  >> /root/.ssh/config
service sshd restart 

# 999 
echo "Richstone 内部服务器： centos 6系统初始化完成"

