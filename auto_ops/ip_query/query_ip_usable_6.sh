#!/bin/bash

#Author: yeweijie
#Time:2017-08-15 14:29:17
#Name:query_ip_usable_6.sh
#Version:V1.0
#Description:用于---- 通过nmap工具获取一个网段的所有IP，并打印到文件中： ip_usable_192.168.6.0.txt


# 定义记录IP使用情况的文件

ip_file="ip_usable_192.168.6.0.txt"

printf "打印当前路径："
printf $PWD
printf ""

# 删除当前路径下的 记录文本
rm  -rf $PWD/$ip_file

# 在文本开头打印相关信息
echo -e  "\n    查询内网IP可用（ping不通）的情况\n\n" >  $PWD/$ip_file


# 执行扫描脚本并将IP信息录入指定文件

/bin/bash  $PWD/get_ip_usable.sh   >>  $PWD/$ip_file 


