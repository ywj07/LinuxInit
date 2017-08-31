#!/bin/bash

# by yeweijie
# 2017-06-16

echo "适用与CentOS 6 的系统"

cd /etc/yum.repos.d
wget   http://192.168.6.184/local-yum/Richstone_local_zabbix_Centos_6.repo
yum makecache

# 

yum install -y zabbix-agent

# 替换配置文件
cd /etc/zabbix/
mv zabbix_agentd.conf zabbix_agentd.conf_bak
wget http://192.168.6.184/zabbix_install/zabbix_agentd.conf


#systemctl start zabbix-agent.service
#systemctl enable zabbix-agent.service

/etc/init.d/zabbix-agent start
chkconfig zabbix-agent on


#

echo -e  "请将本服务器的ip以及hostname 配置到 zabbix-server 的 /etn/hosts  \n 例如： 127.0.0.1 hostname "
