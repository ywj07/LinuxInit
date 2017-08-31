#!/bin/bash


for i in `df -h|sed  '1d'|awk '{print $5}'|cut -d '%' -f 1 `
do
if [ $i -ge 10  ];then
 name=`df -h |grep $i |awk '{print $1}'`
# echo "$name"
 echo "使用率大于70%的分区"
 echo "$name $i"
fi
done

