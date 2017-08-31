#!/bin/bash 


# by yeweijie
# 2017-06-17


# 添加richstone用户，用户jumpserver系统用户的接入，并赋予sudo权限
# 用户密码：  richstone/Richstone123!

echo "创建jumpserver系统用户："

useradd  richstone

echo "Richstone123!" | passwd --stdin richstone

echo -e "\n richstone  ALL=(ALL)       NOPASSWD: ALL " >>  /etc/sudoers

echo "用户密码：  richstone/Richstone123!"

sleep 5
