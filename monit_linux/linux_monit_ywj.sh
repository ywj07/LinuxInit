#!/bin/bash

#获取当前时间，年月日+时分
cur_datetime=`date +%Y%m%d_%H%M`
echo "当前时间"
echo "$cur_datetime"

mkdir  -p /tmp/monit_log/
log_dir="/tmp/monit_log/"
echo -e "############################\n" >> "$cur_datetime"

echo -e "############################\n" >> "$cur_datetime"
python  cpu_1.py >> "$cur_datetime"
echo -e "############################\n" >> "$cur_datetime"

python  cpu_2.py >> "$cur_datetime"
echo -e "############################\n" >> "$cur_datetime"

python  mem.py >> "$cur_datetime" 
echo -e "############################\n" >> "$cur_datetime"

echo "当前磁盘使用情况"  >> "$cur_datetime"
df -h  >> "$cur_datetime"
echo -e "############################\n" >> "$cur_datetime"

bash disk_use.sh   >> "$cur_datetime"
echo -e "############################\n" >> "$cur_datetime"

python  ntp.py >> "$cur_datetime"
echo -e "############################\n" >> "$cur_datetime"

python  net.py >> "$cur_datetime"
echo -e "############################\n" >> "$cur_datetime"


echo -e "查看当前有效的连接数\n"   >> "$cur_datetime"
netstat   -nat  |grep  ESTABLISHED |wc -l >> "$cur_datetime"
echo -e "############################\n" >> "$cur_datetime"
 
echo -e  "检查系统服务器的端口开放状态\n" >>  "$cur_datetime"
nmap -p 0-65535  127.0.0.1 |grep open >> "$cur_datetime"
echo -e "############################\n" >> "$cur_datetime"
