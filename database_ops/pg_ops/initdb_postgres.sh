#!/bin/bash

######################################################
##
##  Purpose: Init Postgresql Automatically
## 
##  Author :Kenyon
##  
##  Created:2014-02-08
## 
##  Version:1.0.0
#####################################################

if [ `whoami` != "postgres" ] ; then
echo "------------------Should be postgres user initdb!!----------------"
exit 1

else

ecgo "-------------------init postgres's environment variables-----------"
cat >> ~/.bash_profile << EOF
#export PGPORT=1949
export PGPORT=5432
export PGHOME=/home/postgres
export PGDATA=/database/pgdata
export PATH=\$PGHOME/bin:\$PATH
export MANPATH=\$PGHOME/share/man:\$MANPATH
export LANG=en_US.utf8
export LD_LIBRARY_PATH=\$PGHOME/lib:\$LD_LIBRARY_PATH

alias pg_stop='pg_ctl -D \$PGDATA stop -m fast'
alias pg_start='pg_ctl -D \$PGDATA start'
alias pg_reload='pg_ctl -D \$PGDATA reload'
EOF

# 使得环境变量生效
source ~/.bash_profile 

#wget http://ftp.postgresql.org/pub/source/v9.3.2/postgresql-9.3.2.tar.gz
wget  http://192.168.6.14:8080/pg/postgresql-9.6.1.tar.gz
#echo "tar -zxvf postgresql-9.3.2.tar.gz"
tar -zxvf postgresql-9.6.1.tar.gz
#tar -zxvf postgresql-9.3.2.tar.gz
cd postgresql-9.6.1


echo "-------------------Configuring PostgreSQL,please wait---------------"
./configure --prefix=/home/postgres --with-pgport=5432 --with-perl --with-python --with-openssl --with-pam --with-ldap --with-libxml --with-libxslt --enable-thread-safety

if [ $? -ne 0 ];then
echo "Configure Postgresql失败，请检查config日志!"
exit 1
fi

echo "-------------------Installing PostgreSQL,please wait----------------"
gmake world
if [ $? -ne 0 ];then
echo "Gmake Postgresql失败 ,请检查日志!"
exit 1
fi

gmake install-world
if [ $? -ne 0 ];then
echo "Gmake install Postgresql failed ,请检查日志!"
exit 1
fi

echo "-----------------Initing Database----------------------------------"

echo "Tc_Pgsql_ky">/tmp/postgres_pwd.txt
initdb -D /database/pgdata -E UTF8 --locale=C -U postgres --pwfile /tmp/postgres_pwd.txt
if [ $? -eq 0 ];then
  echo "---------------安装PostgreSQL成功---"
  rm -f /tmp/postgres_pwd.txt
else
  echo "--------------安装PostgreSQL失败，请检查日志------------"
  exit 1
fi


fi
