#!/bin/sh
# yeweijie
# 2017-02-23

echo "创建/data以及各个数据挂载目录"
mkdir  /data

#mkdir  /data/1
#mkdir  /data/2

for j in {1..24}
do
  echo "开始创建目录：/data/$j "
  echo "mkdir  /data/$j"
  mkdir  /data/$j
  echo "创建目录完成"
  echo "###########"
  sleep 1
done

