#!/bin/bash 

# by yeweijie 
# 2017-07-14
# 最近修改： 2017-08-02

# 用于获取当前集群的IP，对每个IP进行hostname配置、同步hosts以及配置时钟同步的定时任务

HOST_CONF_DIR=/home/hadoop_init/host_conf
HOST_CONF_IP=/home/hadoop_init/host_conf/cluster_ip

# 配置第一、二级域名。例如hantele.com 或者  richstonedt.com
hostname="postgres"
DOMAIN_NAME="hantele.com"

# 局域网内的时钟同步服务器，一般设置为namenode节点
ntp_server="192.168.6.73"

# 定义ansible集群名
CLUSTER=pg

# 判断是否存在该路径，没有则创建
[ -d $HOST_CONF_DIR ] || mkdir -p  $HOST_CONF_DIR

# 重建ip信息的文件
rm -rf  $HOST_CONF_IP
touch $HOST_CONF_IP

# 将秘钥验证的ip信息输入到相关文件
ls /home/hadoop_init/ |grep 192 |awk -F ':' '{print $1}'   >> $HOST_CONF_IP


echo "查看集群IP"
more   $HOST_CONF_IP
# |awk -F '/' '{print $4}'

sleep 5
# 将集群的IP输入到host配置文件：cluster_ips


# 开始修改hostname 以及 /etc/hosts

declare -i num=0

IPS=($(cat $HOST_CONF_IP))

for ip in ${IPS[*]}
do
    # 节点循环，
    echo "打印当前IP:${ip}"
    num+=1
    echo "循环配置host:$num"
    
     /usr/bin/ansible $ip -m command -a "sed -i "s/HOSTNAME=/#HOSTNAME=/g"  /etc/sysconfig/network "
     /usr/bin/ansible $ip -m shell  -a " echo -e 'HOSTNAME=${hostname}${num}.${DOMAIN_NAME}\n' >>  /etc/sysconfig/network" 
     /usr/bin/ansible $CLUSTER -m shell  -a " echo -e ' ${ip}  ${hostname}${num}.${DOMAIN_NAME}' >>  /etc/hosts"
      
done


# 配置每一台服务器的时钟同步
/usr/bin/ansible $CLUSTER -m shell -a " echo -e '#每一台服务器都向节点1做时钟同步' >> /var/spool/cron/root"
/usr/bin/ansible $CLUSTER -m shell -a " echo -e ' */10 * * * *  /usr/sbin/ntpdate -u  ${ntp_server}' >> /var/spool/cron/root"
