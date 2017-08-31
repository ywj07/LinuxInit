#!/bin/bash 

# by yeweijie
# 2017-07-24
# 用于操作系统性能优化，关闭不必要的服务
# 思路：先关闭所有服务，再开启有用的服务
# 用途：本优化还可以应用于安全合规中，“关闭不必要的服务一项”
# 说明：本脚本适用于CentOS 6的系统

# set -x 

# 启用或者on取决于操作系统的默认语言


# 1：关闭所有服务
for serv in $(chkconfig --list |grep 3:启用 |awk -F 0 '{print $1}')
#for serv in $(chkconfig --list |grep 3:on   |awk -F 0 '{print $1}')
do
    echo "关闭服务: ${serv}" 
    chkconfig --level 3 ${serv} off 
done 

# 2：开启需要用到的服务：比如网络,日志，ssh等
for ser in crond network rsyslog sshd udev-post sysstat
do 
	echo "开启服务：${ser}"
	#chkconfig --level 3 $ser
	chkconfig ${ser} on
done 
