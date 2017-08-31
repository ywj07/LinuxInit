#!/bin/bash

#Author: yeweijie
#Time:2017-08-15 14:58:25
#Name:update_ywj.sh
#Version:V1.0
#Description:用于---- 提交代码

# 获取操作系统当前时间，记录提交代码的时间戳

cur_datetime=`date +%Y%m%d_%H%M`

# echo "$@" # 获取传入的所有参数，但空格时区分每个参数，独立输出
echo -e  "$* \n\n" # 获取所有参数，并汇聚为一个字符串


# 提交代码
git add  .
git commit  -am "update by yeweijie:$cur_datetime,"$*" "
git push  origin  master




