#! /bin/bash
# yeweijie
# 2017-02-23

echo "mkfs.ext4 -T largefile /dev/sd*"

for i in {b..y}
do
  echo "$i"
  echo y |  mkfs.ext4 -T largefile /dev/sd$i
  echo "格式化完成"
  sleep 1 
done


