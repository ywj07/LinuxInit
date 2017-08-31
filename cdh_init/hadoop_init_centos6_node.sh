#!/bin/bash 

# by yeweijie
# 20170706

set -x 

export http_proxy=http://192.168.6.78:8118/
export https_proxy=http://192.168.6.78:8118/

#############
echo "配置cloudera"

mkdir  -p /home/hadoop/cdh5
cd /home/hadoop/cdh5

wget http://192.168.6.14:8080/cdh/5.11/cloudera-manager-daemons-5.11.1-1.cm5111.p0.9.el6.x86_64.rpm
rpm -ivh cloudera-manager-daemons-5.11.1-1.cm5111.p0.9.el6.x86_64.rpm

wget http://192.168.6.14:8080/cdh/5.11/cloudera-manager-agent-5.11.1-1.cm5111.p0.9.el6.x86_64.rpm
rpm -ivh cloudera-manager-agent-5.11.1-1.cm5111.p0.9.el6.x86_64.rpm


#yum install cloudera-manager-agent -y

rpm -ql cloudera-manager-daemons
sleep 10

rpm -ql cloudera-manager-agent
sleep 10








