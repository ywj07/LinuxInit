#!/bin/bash

# by yeweijie
# 2017-08-10


#  修改集群root用户密码
# echo "Hantele@1234!" | passwd --stdin root

# 设置修改密码的用户，以及新密码
password="Hantele@1234!"
user="root"

# 设置要进行修改密码的集群
CLUSTER=hadoop


/usr/bin/ansible ${CLUSTER} -m shell  -a "echo "${password}" | passwd --stdin ${user} "


