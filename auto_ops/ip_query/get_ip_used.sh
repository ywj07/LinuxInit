#!/bin/bash

#Author: yeweijie
#Time:2017-08-15 14:26:58
#Name:get_ip_used.sh
#Version:V1.0
#Description:用于----  使用nmap  工具获取一个网段的所有IP
# 本脚本适用于CentOS 6的操作系统，并需要提前安装 nmap 工具 ： yum install nmap -y 



# 定义扫描的网段及掩码
subnet="192.168.6.0/24"

#使用nmap  工具获取一个网段的所有IP


nmap  -sP $subnet |grep "Nmap scan report" |cut -d '' -f 5

