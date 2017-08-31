#!/bin/bash

#Author: yeweijie
#Time:2017-08-15 14:48:54
#Name:get_ip_usable.sh
#Version:V1.0
#Description:用于----  通过ping 检查当前网络中不通的IP

IP="192.168.6"
MAX_THREAD_NUM=10

echo "未使用IP"
echo -e "根据是否ping通，打印不能ping通的IP：\n"

for i in `seq 1 254`

do
  (
    ping -c 1 ${IP}.${i} &>/dev/null
    if [ $? -ne 0 ];then
#      echo "${IP}.${i} can not reachable"
      echo "${IP}.${i}"
    fi
  )&
  
  num_ping=`ps -ef | grep "ping" | grep -v grep | wc -l`
  if [ "${num_ping}" -gt "${MAX_THREAD_NUM}" ];then
    sleep 1
  fi
done

wait 
