#!/bin/bash

#Author: yeweijie
#Time:2017-08-15 15:49:38
#Name:init_telnet.sh
#Version:V1.0
#Description:用于---- CentOS6配置telnet



#openssh升级到openssh-7.5p1 的过程

# 1: 启用telnet 防止断开后不能远程登陆

# 先关闭防火墙，否则telnet可能无法连接
service iptables stop
chkconfig iptables off

# 配置 telnet登录
#yum install telnet* -y
yum -y install telnet
yum -y install telnet-server
yum -y install xinetd  


# vi /etc/xinetd.d/telnet
#将其中disable字段的yes改为no以启用telnet服务

sed -i "s/yes/no/"  /etc/xinetd.d/telnet

#允许root用户通过telnet登录
mv /etc/securetty /etc/securetty_bak    

#启动telnet服务
service xinetd restart                   

#使telnet服务开机启动，避免升级过程中服务器意外重启后无法远程登录系统
#/etc/xinetd.d/telnet

chkconfig xinetd on                     
# telnet [ip]                             #新开启一个远程终端以telnet登录验证是否成功启用 

#升级完成建议关闭telnet
# vi /etc/xinetd.d/telnet
#将其中disable字段的no改为yes以启用telnet服务
#service xinetd restart
