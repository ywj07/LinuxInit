#!/bin/bash 

#by yeweijie
# 2017-07-28

# 本脚本用于自动更新mysql infobright的license

# 如果乱码
# set encoding=utf-8
# set -x 

# 进入chroot . 环境后执行本脚本
# 执行格式：  bash  脚本名   当前年月日
# bash   auto_update_license.sh  20170726


CUR_DATE=$1
echo $CUR_DATE
Length=$(/bin/echo $CUR_DATE |wc -L) 
# awk '{print length($0)}' 
# test=$(/bin/echo CUR_DATE  |wc -L)
#echo "test:$test"

echo -e "输入字符串长度： Length:$Length \n"
sleep 5


#######################################
update(){
#进入数据库环境

echo -e "请确认已进入：chroot . \n"
sleep 5

#关闭mysql服务
echo -e  "关闭mysql服务\n"
echo -e  "先检查是否还有数据库进程\n"
ps -ef|grep mysql

sleep 3


echo -e "\n数据库服务已关闭，进行确认"
ps -ef|grep mysql|grep -v grep|awk '{print $2}'|xargs kill -9 
ps -ef|grep mysql

#进行日志备份 
echo -e "\n\n进行日志备份"
/bin/mv  /home/ib_iee/data/brighthouse.log   /home/ib_iee/data/brighthouse.log_${CUR_DATE}
/bin/mv /home/ib_iee/data/general_query.log  /home/ib_iee/data/general_query.log_${CUR_DATE}

echo -e "\n\n查看备份日志"
ls -lh /home/ib_iee/data/*${CUR_DATE}
sleep 3
echo -e "\n\n\n"



# 进入license目录
#[ -d  /usr/local/infobright ] && cd  /usr/local/infobright

OLD_LICENSE=$( ls /usr/local/infobright/ |grep  iblicense-  )
echo -e "\n\n旧的license： $OLD_LICENSE"

NEW_LICENSE=$( ls /usr/local/ |grep  iblicense- )
echo -e "\n新的license： $NEW_LICENSE"

echo -e  "\n根据新的license有效期进行时间更新，替换新旧license"
# 具体操作

# 获取时间信息
MYSQL_DATE=$( more /usr/local/$NEW_LICENSE  |grep Start |awk -F = '{print $2}')
MYSQL_TIME=$( /bin/date +%H:%M )
echo "打印新的时间信息"
echo -e "MYSQL_DATE:$MYSQL_DATE\n"
echo -e "MYSQL_TIME:$MYSQL_TIME\n"
sleep 3

# 替换license
mv /usr/local/infobright/$OLD_LICENSE  /usr/local/
mv /usr/local/$NEW_LICENSE  /usr/local/infobright/


#修改系统时间
echo "查看当前时间"
/bin/date
echo -e "\n 修改系统日期和时间---"
/bin/date -s $MYSQL_DATE
/bin/date -s $MYSQL_TIME
echo -e "\n 修改后的时间---------"
/bin/date 
sleep 5

echo -e "\n重启nscd服务"
/usr/sbin/service nscd stop
/usr/sbin/service nscd start 


#启动mysql服务

echo -e "\n\n 启动mysqld-ib 服务------"
/usr/sbin/service mysqld-ib start
sleep 3

# 确认是否还有数据库进程
echo -e "\n\n确认数据库服务已恢复\n"
ps -ef|grep mysql
sleep 3

echo -e "\n\n#####注意：如果mysqld-ib启动失败，请根据相关日志进行排查！！！\n"
exit 0
}
##############################################



if [ "$Length" = "8" ]
   then
# 如果输入的字符串为8位，则执行更新函数
	update
else
	echo "请输入当前的时间，用于日志备份：格式如：20170726，8位年月日"
	exit 1
fi


