#!/bin/bash 

# by yeweijie
# 2017-08-18

#定义挂载的分区
PART=vda4


#echo y |mkfs.ext4 -T largefile /dev/$PART

echo y |mkfs.ext4  -i 16384 /dev/$PART


mkdir  /home/data
mkdir  /home/data/$PART


mount -t ext4 /dev/$PART /home/data/$PART

 echo  "/dev/$PART                /home/data/$PART                ext4    defaults        0 0 ">>/etc/fstab 

