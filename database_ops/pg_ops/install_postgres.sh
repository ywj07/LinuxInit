#!/bin/bash

######################################################
##
##  Purpose:Install Postgresql Automatically
## 
##  Author :Kenyon
##  
##  Created:2014-02-08
## 
##  Version:1.0.0
#####################################################

echo "--------------------Check current OS datetime---------------------"

DATE=`date +"%Y-%m-%d %H:%M:%S"`

echo "------系统当前时间: $DATE------------------"
echo "------确保系统时间不早于实际时间----------"
echo "------请输入 Y or N 继续-----------------"
read input
if [ "$input" = "N" -o "$input" = "n" ]; then
echo "-------------------Modify OS datetime correctly,exit install!-----"
exit 1

elif [ "$input" = "Y" -o "$input" = "y" ];then
echo "---------------------start install PostgreSQL---------------------"
yum install -y wget perl-ExtUtils-Embed readline-devel zlib-devel pam-devel libxml2-devel libxslt-devel openldap-devel python-devel gcc-c++ openssl-devel cmake
mkdir -p /database/pgdata

echo "---------------------create postgres user if not exist------------"
if [ `grep "postgres" /etc/passwd | wc -l` -eq 0 ];then
echo "adding user postgres"
/usr/sbin/groupadd postgres
/usr/sbin/useradd postgres -g postgres
echo "postgres"|passwd --stdin  postgres
else
echo "--------------  the user of Postgres is already exist,ignore useradd"
fi

cd /database
chown -R postgres:postgres  ./pgdata

echo "---------------------download PostgreSQL source code----------------"
cd /tmp
chown postgres:postgres ./initdb_postgres.sh
chmod u+x ./initdb_postgres.sh
su - postgres -c /tmp/initdb_postgres.sh

else
echo "--------------------输入错误，请输入 Y or N-------------------"
exit 1
fi
