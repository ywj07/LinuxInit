#!/bin/bash

# by yeweijie
# 2017-06-23

# 在基于配置了epel，使用yum的方式进行配置gmond


yum install ganglia-gmond -y
sleep 2

# 配置文件变更
# cd /etc/ganglia/
# mv gmond.conf gmond.conf_bak
# wget http://192.168.6.184/gmond/gmond.conf

# 启动服务并配置开机自启动

systemctl  restart gmond.service
systemctl  enable  gmond.service
sleep 3

# 定时重启gmond

echo "#gmond  monit" >> /var/spool/cron/root
echo "10  * * * *  systemctl  restart gmond.service  "  >> /var/spool/cron/root


echo "centos 7的gmond配置完成"


