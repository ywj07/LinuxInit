#!/bin/bash
# by yeweijie
# 2017-08-09
# 使用本地epel安装gmond，并修改部分配置文件


# 获取当前服务器时间
cur_datetime=`date +%Y%m%d_%H%M`
# 相应客户端的配置文件
gmond_file=gmond.conf_foshan_pg



yum -y install  ganglia-gmond
service gmond restart
chkconfig --add gmond
chkconfig gmond on
#替换gmond配置文件

cd /etc/ganglia/
mv gmond.conf gmond.conf_$cur_datetime
wget  http://192.168.5.109/gmond/${gmond_file}
cp  ${gmond_file} gmond.conf
service gmond restart

echo -e "change gmond.conf  successfully\n"
sleep 2


#添加gmond进程监控
echo -e "添加gmond进程重启\n"
sleep 3
echo "#gmond  monit" >> /var/spool/cron/root
echo "1 * * * *  service gmond restart "  >> /var/spool/cron/root


echo -e "gmond模块配置完成\n"
sleep 5
