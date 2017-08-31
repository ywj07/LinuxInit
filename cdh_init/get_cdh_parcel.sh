#!/bin/bash 

# by yeweijie
# 2017-07-14


# 创建cdh包的备份目录
CDH_DIR=/opt/cloudera/bak
mkdir  $CDH_DIR

cd $CDH_DIR



wget http://192.168.6.14:8080/cdh/5.9/CDH-5.9.0-1.cdh5.9.0.p0.23-el6.parcel

wget http://192.168.6.14:8080/cdh/5.9/CDH-5.9.0-1.cdh5.9.0.p0.23-el6.parcel.sha1

# 拷贝并修改命名


cp CDH-5.9.0-1.cdh5.9.0.p0.23-el6.parcel.sha1 CDH-5.9.0-1.cdh5.9.0.p0.23-el6.parcel.sha

wget http://192.168.6.14:8080/cdh/5.9/manifest.json

# 获取文件并赋予可执行权限
wget http://192.168.6.14:8080/cdh/5.9/cloudera-manager-installer.bin
chmod +x cloudera-manager-installer.bin
