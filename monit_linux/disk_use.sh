#!/bin/bash

# by xujingrui
# 2017-03-27

echo "打印使用率大于70%的分区"
for i in `df -h |sed '1d' |awk '{print $1}'`
do
 sum=`df -h|grep $i|awk '{print $5}'|cut -d '%' -f 1`
 if [ $sum -ge 70 ];then
  echo "$i $sum%"
fi
done

