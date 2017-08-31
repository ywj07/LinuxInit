#!/bin/bash 

# by yeweijie
# 20170706

set -x 

cd /root
wget http://192.168.6.184/linux_init/get_centos6_init_shell.sh
bash  get_centos6_init_shell.sh
sleep  5 

yum update -y 


#sed -i "s/192.168.111.5/192.168.6.142/g"  /etc/ganglia/gmond.conf
#sed -i "s/Openstack_Test/Hadoop_ywj/g"  /etc/ganglia/gmond.conf

#service gmond restart 


########################################
配置ansible环境

yum install  ansible -y 
sed -i "s/#host_key_checking/host_key_checking/g"  /etc/ansible/ansible.cfg



########################################
echo "初始化系统配置"
sleep 10 

cd /etc/yum.repos.d/
# wget  https://archive.cloudera.com/cm5/redhat/6/x86_64/cm/cloudera-manager.repo
wget http://192.168.6.14:8080/cdh/cloudera-manager.repo
yum clean all
yum makecache 


###########################
#echo "生产密钥对"
#ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
#  ssh-copy-id  IP

# 此部分功能单独完成



#############
echo "HADOOP基础配置项"
# 安装部分基础工具
yum -y install mod_ssl python-psycopg2 MySQL-python


# 检查主机正确性，会遇到的问题，需要修改开机启动
#  echo 10 > /proc/sys/vm/swappiness
#  echo never > /sys/kernel/mm/transparent_hugepage/defrag

echo " echo 10 > /proc/sys/vm/swappiness " >> /etc/rc.local
echo " echo never > /sys/kernel/mm/transparent_hugepage/defrag  " >> /etc/rc.local

# 关闭IPV6
echo " alias net-pf-10 off " >> /etc/modprobe.d/dist.conf
echo " alias ipv6 off " >> /etc/modprobe.d/dist.conf
echo " NETWORKING_IPV6=no " >> /etc/sysconfig/network

# 注释掉IPv6行 /etc/hosts
sed -i "s/::1 /#::1 /g"   /etc/hosts

# 打开句柄限制，所有机器都要执行
cat >> /etc/security/limits.conf <<EOF
hadoop   soft    nproc   20470
hadoop   hard    nproc   163840
hadoop   soft    nofile  10240
hadoop   hard    nofile  655360
hadoop   soft    stack   10240
EOF
# 

echo -e "\nsession    required     pam_limits.so"  >> /etc/pam.d/login

###################################
echo "配置jdk"
mkdir -p /home/hadoop/tools
cd  /home/hadoop/tools
wget http://192.168.6.14:8080/cdh/oracle-j2sdk1.7-1.7.0+update67-1.x86_64.rpm

rpm -ivh oracle-j2sdk1.7-1.7.0+update67-1.x86_64.rpm
# 修改系统环境变量
echo '#####addtion start###########' >>/root/.bash_profile
echo 'export JAVA_HOME=/usr/java/jdk1.7.0_67-cloudera/' >>/root/.bash_profile
echo 'export PATH=$JAVA_HOME/bin:$PATH' >>/root/.bash_profile
echo '#####addtion end###########' >>/root/.bash_profile

# 生效

source /root/.bash_profile
java -version 
echo -e "JDK已配置成功\n"
sleep 3


####################
echo "配置ntp"
yum install ntp -y
sed -i "s/#restrict 192.168.1.0/restrict 192.168.6.0/g"  /etc/ntp.conf
sed -i "s/server 0.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/"   /etc/ntp.conf
sed -i "s/server 1.centos.pool.ntp.org/#server 1.centos.pool.ntp.org/"   /etc/ntp.conf
sed -i "s/server 2.centos.pool.ntp.org/#server 2.centos.pool.ntp.org/"   /etc/ntp.conf
sed -i "s/server 3.centos.pool.ntp.org/#server 3.centos.pool.ntp.org/"   /etc/ntp.conf
# 配置NTP Server的层数提供本地服务
echo "server 127.127.1.0"  >>  /etc/ntp.conf
echo "fudge 127.127.1.0 stratum 8"  >>  /etc/ntp.conf

/sbin/service ntpd start
chkconfig ntpd on



#############
# 关闭虚拟网卡,解决端口速率不一致问题
 virsh net-list
 virsh net-destroy default
 virsh net-undefine default
 service libvirtd restart


##############




######################
# 配置时钟同步
#  /usr/sbin/ntpdate  
# 由ansible配置，设置节点1为同步源
 


echo "请进行重启：reboot 或者init 6"
