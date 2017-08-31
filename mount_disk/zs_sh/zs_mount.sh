#!/bin/bash 
# yeweijie
# 2017-02-23


df -h 
sleep 3

echo "挂盘命令：mount -t ext4 /dev/sd$i /data/$j"

declare -i  j=0
for i in {b..y}
do
  j+=1
  echo ${j}
  echo "挂载盘符：$i"
  echo " mount -t ext4 /dev/sd$i /data/$j"
  mount -t ext4 /dev/sd$i /data/$j
  echo "挂载完成"
  sleep 1
done

df -h
