#! /bin/bash
# yeweijie
# 2017-04-13

echo "mkfs.ext4 -T largefile /dev/sd*"

for i in {a..k}
do
  echo "$i"
  echo y |  mkfs.ext4 -T largefile /dev/sd$i
  echo y |  mkfs.ext4 -T largefile /dev/sdm
  echo "格式化完成"
  sleep 1 
done


