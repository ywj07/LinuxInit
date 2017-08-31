#!/bin/bash

#Author: yeweijie
#Time:2017-08-15 15:50:53
#Name:update_sshssl.sh
#Version:V1.0
#Description:用于---- 升级sshssl，修复漏洞



#查看openssl现状
openssl version -a
sleep 3

#OpenSSL 1.0.1e-fips 11 Feb 2013
#built on: Wed Mar 22 21:43:28 UTC 2017
#platform: linux-x86_64

#Dir=/home/update_sshssl
Dir="$( cd "$( dirname "$0"  )" && pwd  )"

# 0: 关闭 防火墙以及selinux

service iptables stop 
chkconfig iptables off 

setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/"   /etc/selinux/config

# 1: 升级 openssl
# 1.1: 先安装一个openssl-fips 
cd $Dir
tar -zxvf openssl-fips-2.0.14.tar.gz
cd openssl-fips-2.0.14
./config

make

make install

#安装openssl-fips 完毕
echo "安装openssl-fips 完毕" 
sleep 3 



# 1.2:安装openssl-1.0.2k
cd $Dir
tar -zxvf openssl-1.0.2k.tar.gz
cd openssl-1.0.2k
./config
make
make test
make install   
#(以上3补都不可以报错)
echo "安装openssl-1.0.2k 完毕"
sleep  3 

#检查文件是否安装成功 
echo "检查文件是否安装成功"
ls /usr/local/ssl/
sleep 5
#bin/         fips-2.0/    lib/         misc/        private/     
#certs/       include/     man/         openssl.cnf  

# 备份文件
mv /usr/bin/openssl /usr/bin/openssl_bak
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl


#查看版本
openssl version -a
#OpenSSL 1.0.2k  26 Jan 2017
sleep 3

# 2: 安装ssh

# openssh-7.5p1.tar.gz

#安装 gcc、openssl和zlib
yum install gcc  zlib-devel  pam-devel.x86_64 -y

#解压并编译安装
cd $Dir
tar -zxvf openssh-7.5p1.tar.gz
cd openssh-7.5p1
./configure   --prefix=/usr   --sysconfdir=/etc/ssh   --with-md5-passwords   --with-pam   --with-tcp-wrappers   --with-ssl-dir=/usr/local/ssl   --without-hardening
make
make install

# 3: 备份原文件
mv /etc/init.d/sshd /etc/init.d/sshd_bak
cp -a /etc/ssh /etc/ssh_bak

#拷贝ssh服务文件
cd $Dir
cp -a  openssh-7.5p1/contrib/redhat/sshd.init /etc/init.d/sshd
chmod +x /etc/init.d/sshd
chkconfig --add sshd

cd $Dir
cp -a openssh-7.5p1/ssh_config /etc/ssh/ssh_config
cp -a openssh-7.5p1/sshd_config /etc/ssh/sshd_config
#（如原来有特殊配置的  需要重新配置sshd_config文件 默认root不能登陆）
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config

# 4:重启服务并测试
/etc/init.d/sshd restart
#Stopping sshd:[  OK  ]
#Starting sshd:[  OK  ]

# 5:完成升级
echo "查看ssh版本是否为： OpenSSH_7.5p1, OpenSSL 1.0.2k  26 Jan 2017"
#OpenSSH_7.5p1, OpenSSL 1.0.2k  26 Jan 2017
ssh -V


echo "升级完成"

