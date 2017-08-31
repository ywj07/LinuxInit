#!/bin/bash 

# by yeweijie
# 2017-06-07

# devstack  自动部署openstack的方案， 单机

# 0: 初始化环境
# 关闭防火墙、selinux、更新本地镜像配置

systemctl  stop  firewalld.service
systemctl  disable  firewalld.service

setenforce   0 
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g"  /etc/selinux/config


cd /etc/yum.repos.d/
mkdir bak
mv CentOS-*.repo bak/ 
wget http://192.168.6.184/local-yum/Richstone_local_yum_Centos_7.repo
wget http://192.168.6.184/local-yum/Richstone_local_epel_Centos_7.repo
wget http://192.168.6.184/local-yum/Richstone_local_qemu-ev_Centos_7.repo
wget http://192.168.6.184/local-yum/Richstone_local_rdo-release_Centos_7.repo


yum clean all 
yum makecache 
sleep 5 

# 1: 配置python环境

mkdir -p ~/.pip          # 使用豆瓣pip源
#vim ~/.pip/pip.conf
echo -e "[global]\n" >> ~/.pip/pip.conf
# 清华的源比豆瓣的源快很多
echo -e "index-url = https://pypi.tuna.tsinghua.edu.cn/simple/   \n " >> ~/.pip/pip.conf
yum -y  install  python-pip
pip install --upgrade pip


# 2: 获取文件包：
yum install -y screen 
yum install -y git  # 安装git
cd /home
#git clone https://github.com/openstack-dev/devstack.git 
wget http://192.168.6.114/richstonedt_mirrors/openstack_ywj/devstack.tar.gz
tar -zxvf  devstack.tar.gz

# 2.1: 创建用户

echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "执行  /home/devstack/tools/create-stack-user.sh"
sleep 5 
cd /home/devstack/tools/    # devstack默认不能以root身份运行
/bin/bash   create-stack-user.sh      # 会创建一个stack用户
chown -R stack. /home/devstack


# 配置local.conf 文件
#su stack
cd  /home/devstack/

cat >>  /home/devstack/local.conf <<"EOF"
[[local|localrc]]
ADMIN_PASSWORD=123456
DATABASE_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD

EOF


chown -R stack. /home/devstack

more  /home/devstack/local.conf


sleep 3 


# 3： 配置基础环境
# 3.1： ntp 
yum -y  install ntp
systemctl  start  ntpd.service
systemctl  enable  ntpd.service

# 


echo "init successfully"

