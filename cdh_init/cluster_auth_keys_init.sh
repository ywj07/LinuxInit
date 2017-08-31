#!/bin/bash

##########################################
# by yeweijie
# 20170719
# 本脚本通过shell和ansible，对一个集群的服务器进行统一用户(root)统一密码的免秘钥配置
# 1：在ansible服务器上进行 集群的配置，# vim /etc/ansible/hosts
# [hadoop] 中的hadoop为集群名，与脚本中的CLUSTER的值要对应，ansible_ssh_user以及ansible_ssh_pass配置为统一的用户和密码
#[hadoop]
#192.168.6.14[2:3]
#192.168.6.149
#
#[hadoop:vars]
#ansible_ssh_user=root
#ansible_ssh_pass=888888

# 2: 以后补充 


##########################################


set -x 
# 定义ansible CLUSTER中的集群名


CLUSTER=cdh
#CLUSTER=hadoop

mkdir /home/hadoop_init
DIR_INIT=/home/hadoop_init

# 修改ansible环境
yum install ansible -y
sed -i "s/#host_key_checking/host_key_checking/g"  /etc/ansible/ansible.cfg


  
/usr/bin/ansible $CLUSTER   -m ping

 /usr/bin/ansible $CLUSTER   -m command -a " rm -rf /root/.ssh/id_rsa"
 /usr/bin/ansible $CLUSTER   -m command -a " rm -rf /root/.ssh/id_rsa_pub"
 /usr/bin/ansible $CLUSTER   -m command -a "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa"

 /usr/bin/ansible $CLUSTER   -m fetch -a "src=/root/.ssh/id_rsa.pub dest=$DIR_INIT  remote_src=True"
  



rm -rf ./authorized_keys.txt
aut_txt()
    {
        dir=$1
        cat "$dir/root/.ssh/id_rsa.pub" >> $DIR_INIT/authorized_keys.txt

    }

#echo  $dir

for dir in $(ls $DIR_INIT/192*|grep 192 |awk -F':' '{print $1}')
do
  echo "打印路径：$dir"
  #"ls -a $dir/root/.ssh/ "
  #bash  "cat $dir/root/.ssh/id_rsa.pub >> $DIR_INIT/authorized_keys.txt"
  # 在do循环中的命令读取不到隐藏文件，以下调用aut_txt()并将相关IP对应的目录传入
  aut_txt "${dir}"
done

 
/usr/bin/ansible $CLUSTER   -m copy -a "src=$DIR_INIT/authorized_keys.txt  dest=/root/.ssh/authorized_keys backup=yes"

/usr/bin/ansible $CLUSTER   -m command -a "ls -lh /root/.ssh/"

echo "集群的免秘钥登录已配置完成 "
sleep 5

exit 0
