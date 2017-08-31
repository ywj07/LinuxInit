#!/bin/bash
 
cd   /etc/yum.repos.d
#创建备份目录
mkdir bak
mv   *.repo*    bak/
wget  http://192.168.6.184/local-yum/Richstone_local_yum_Centos_6.repo
yum  clean all
yum  makecache
