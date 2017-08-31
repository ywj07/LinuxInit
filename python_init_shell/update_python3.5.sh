#!/bin/bash 

# by yeweijie
# 2017-06-09

cd  /opt

wget  http://192.168.6.114/richstonedt_mirrors/openstack_ywj/Python-3.5.3.tgz

tar  -zxvf  Python-3.5.3.tgz

cd  Python-3.5.3

mkdir  /usr/python3.5
./configure  --prefix=/usr/python3.5
make 
make install 

sleep 5 


# 让系统默认使用python3.5
cd   /usr/bin 
mv python python_bak
ln -s /usr/python3.5/bin/python3  /usr/bin/python 


# 修改yum配置
# /usr/bin/yum 

sed -i "s/bin\/python/bin\/python2.7/g"  /usr/bin/yum


# 解决更新后 yum时出现的问题
# 以下文件也要修改，指向python旧版本
sed -i "s/bin\/python/bin\/python2.7/g"  /usr/libexec/urlgrabber-ext-down
