#! /bin/bash 
# yeweijie
# 2017-02-23

echo "/dev/sdb                /data/1                 ext4    defaults        0 0"

declare -i  j=0
for i in {b..y}
do
  j+=1
  echo ${j}
  echo "挂载盘符：$i"
  echo "/dev/sd$i                /data/$j                 ext4    defaults        0 0 "
  echo  "/dev/sd$i                /data/$j                 ext4    defaults        0 0 ">>/etc/fstab 
  
  echo "修改fstab完成"
  sleep 1
done


