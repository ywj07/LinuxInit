#!/bin/bash
# by yeweijie
# 2017-07-02
# 使用本地epel安装gmond，并修改部分配置文件

mkdir  /home/linux_init
dir=/home/linux_init

cur_datetime=`date +%Y%m%d_%H%M`


#部署监控模块 ： gmond 
#cd $dir
yum -y install  ganglia-gmond
service gmond restart
chkconfig --add gmond
chkconfig gmond on
#替换gmond配置文件

update_conf(){
cd /etc/ganglia/
mv gmond.conf gmond.conf_$cur_datetime
wget  http://192.168.6.184/gmond/gmond.conf_openstack_ganglia
cp gmond.conf_openstack_ganglia  gmond.conf
service gmond restart
}

# update_conf 
# 该功能暂不使用，在另外的脚本中实现

echo -e "change gmond.conf  successfully\n"
sleep 5 


#添加gmond进程监控
echo -e "添加gmond进程重启\n"
sleep 3
echo "#gmond  monit" >> /var/spool/cron/root
echo "1 * * * *  service gmond restart "  >> /var/spool/cron/root


echo -e "gmond模块配置完成\n"
sleep 5
