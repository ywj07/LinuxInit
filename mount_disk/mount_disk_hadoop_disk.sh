#!/bin/bash 

# by yeweijie
# 2017-07-26

set -x 

#定义挂载的分区
PART=vdc

echo -e "挂载分区：/dev/${PART} \n\n"
# 以大文件的方式进行格式化，该格式化速度快，适合hadoop业务的文件系统

echo y |mkfs.ext4 -T largefile /dev/$PART

[ ! -d /home/data ] &&  mkdir -p /home/data

#mkdir  /home/data
mkdir -p /home/data/$PART


mount -t ext4 /dev/$PART /home/data/$PART

 echo  "/dev/$PART                /home/data/$PART                ext4    defaults        0 0 ">>/etc/fstab 

echo "查看是否存在新挂载的盘"
df -h |grep /dev/$PART



