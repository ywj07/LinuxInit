#!/bin/bash

# by yeweijie
# 2017-06-09

# 获取openstack 各个组件的代码： 从github获取，06月8日
# 本脚本使用stack用户执行

mkdir  /opt/stack/
cd  /opt/stack

wget   http://192.168.6.114/richstonedt_mirrors/openstack_ywj/openstack_dev_ywj.tar.gz

tar  -zxvf  openstack_dev_ywj.tar.gz




rm  -rf openstack_dev_ywj.tar.gz


chown -R stack. /opt/stack/ 
