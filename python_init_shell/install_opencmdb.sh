#!/bin/bash 

# by yeweijie
# 2017-06-13


# 安装mysql
 yum install mysql*  -y
 
service mysqld start

chkconfig mysqld on


# 配置和下载opencmdb 代码以及相关环境


mkdir -p /opt/opencmdb

yum  install git  -y

cd /opt/opencmdb && git clone https://github.com/oysterclub/open-cmdb.git

cd open-cmdb/ 

mkdir -p /opt/opencmdb/envs


pip  install  virtualenv

virtualenv -p /usr/local/bin/python2.7 /opt/opencmdb/envs
source /opt/opencmdb/envs/bin/activate

# 进入env环境
pip install -r requirements.txt

# 执行 install Django-1.7.1 IPy-0.83 MySQL-python-1.2.5 PyYAML-3.12 django-filter-0.11.0 djangorestframework-3.3.1 markdown-2.6.7

