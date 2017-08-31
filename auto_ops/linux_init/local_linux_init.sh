#!/bin/bash

#Author: yeweijie
#Time:2017-08-16 17:25:57
#Name:local_linux_init.sh
#Version:V1.0
#Description:用于----  CentOS 的初始化配置，详细如下

###########################################################################
# 本脚本用于刚安装完系统的CentOS 6的操作系统进行一些初始化工作：具体如下
# 0:关闭防火墙以及selinux
# 1:修改本地yum配置
# 2:添加epel源配置，本地镜像服务器
# 3:添加日志记录模块
# 4:安装网络监控工具：iftop
# 5:安装screen工具
# 6:安装系统监控工具 glances
# 7:ssh登陆之忽略known_hosts文件
###########################################################################


# 定义初始配置的路径
DIR=/home/linux_init
[ -d $DIR ] || mkdir -p  $DIR

# 获取系统当前时间
cur_datetime=`date +%Y%m%d_%H%M`

# 0:关闭防火墙以及selinux
stop_iptables_selinux(){
service iptables stop
chkconfig iptables off
echo -e  "/sbin/service  iptables stop \n" >> /etc/rc.d/rc.local 

setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g"   /etc/selinux/config
}


# 获取初始化系统的脚本
get_script(){
cd $DIR
# 获取yum配置文件
wget  http://192.168.6.184/local-yum/Richstone_local_yum_Centos_6.repo
wget http://192.168.6.184/local-yum/Richstone_local_epel_Centos_6.repo
# 日志记录脚本
wget  http://192.168.6.184/linux_init/commandhist.sh

}


# 1:修改本地yum配置
# 2:添加epel源配置，本地镜像服务器
# 更新yum配置文件并重建环境
update_yum_conf(){
cd   /etc/yum.repos.d
#创建备份目录
mkdir bak_${cur_datetime}
mv   *.repo*    bak_${cur_datetime}/
cp $DIR/*.repo   .
yum clean all
yum makecache
}


# 3:添加日志记录模块
history_log(){
cd $DIR
source  commandhist.sh
sleep  3

}

# 4:安装网络监控工具 iftop 
# 5:安装screen工具
# 6:安装系统监控工具 glances

yum_tools(){
echo -e  "安装网络监控工具 iftop\n"
yum -y install  iftop
sleep 2

echo -e  "安装分屏工具 screen\n"
yum -y install screen 
sleep 2

echo -e  "安装系统监控工具 glances\n"
yum -y install  glances
sleep 2 
}

# 7:ssh登陆之忽略known_hosts文件
ssh_no_hosts(){
echo "StrictHostKeyChecking no"  >> /root/.ssh/config
service sshd restart 
}




function main(){
# 关闭防火墙和selinux
stop_iptables_selinux
# 获取初始化配置文件和脚本
get_script
# 更新yum配置
update_yum_conf
# 记录操作命令日志
history_log
# 通过yum安装一些工具
yum_tools
# ssh登陆之忽略known_hosts文件
ssh_no_hosts

# 999
echo -e "Richstone 内部服务器： centos 6系统初始化完成\n\n"
}

################################
# 调用main
main
################################
