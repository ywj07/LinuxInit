#!/bin/bash 
# yeweijie
# 2017-04-13


df -h 
sleep 3

echo "挂盘命令：mount -t ext4 /dev/sd$i /data/$j"

declare -i  j=0
for i in {a..k}
do
  j+=1
  echo ${j}
  echo "挂载盘符：$i"
  echo " mount -t ext4 /dev/sd$i /data/$j"
  mount -t ext4 /dev/sd$i /data/$j
  mount -t ext4 /dev/sdm /data/13
  echo "挂载完成"
  sleep 1
done

df -h
