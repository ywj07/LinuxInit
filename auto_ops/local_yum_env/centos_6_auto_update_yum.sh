#!/bin/bash
# base value
#YUM_SITE="rsync://mirrors.kernel.org/centos/"
#YUM_SITE="rsync://mirrors.aliyun.com/centos/"
#YUM_SITE="rsync://mirrors.163.com/centos/"   # 网易不支持该同步
YUM_SITE="rsync://mirror.tuna.tsinghua.edu.cn/centos/"
#LOCAL_PATH="/u01/mirrors/centos/"
LOCAL_PATH="/var/www/html/richstonedt_mirrors/centos/"
LOCAL_VER='6'
BW_limit=5024
LOCK_FILE="/var/log/yum_server_6.pid"
RSYNC_PATH=""
cur_datetime=`date +%Y%m%d_%H%M`
echo "$cur_datetime"

# check update yum server  pid
MY_PID=$$
if [ -f $LOCK_FILE ]; then
    get_pid=`/bin/cat $LOCK_FILE`
    get_system_pid=`/bin/ps -ef|grep -v grep|grep $get_pid|wc -l`
    if [ $get_system_pid -eq 0 ] ; then
        echo $MY_PID>$LOCK_FILE
    else
        echo "Have update yum server now!"
        exit 1
    fi
else
    echo $MY_PID>$LOCK_FILE
fi

# check rsync tool
if [ -z $RSYNC_PATH ]; then
    RSYNC_PATH=`/usr/bin/whereis rsync|awk ' ''{print $2}'`
    if [ -z $RSYNC_PATH ]; then
        echo 'Not find rsync tool.'
        echo 'use comm: yum install -y rsync'
    fi
fi

# sync yum source
for VER in $LOCAL_VER;
do 
    # Check whether there are local directory
    if [ ! -d "$LOCAL_PATH$VER" ] ; then
        echo "Create dir $LOCAL_PATH$VER"
        `/bin/mkdir -p $LOCAL_PATH$VER`
    fi
    # sync yum source
    echo "Start sync $LOCAL_PATH$VER"
    $RSYNC_PATH -avrtH --delete --bwlimit=$BW_limit --exclude "isos" --exclude "i386" $YUM_SITE$VER $LOCAL_PATH
done

# clean lock file
`/bin/rm -rf $LOCK_FILE`

echo 'sync end.' 

echo -e "\nupdate successfully" >> /var/www/html/richstonedt_mirrors/centos/yum_6_update.log

echo -e "cur_datetime:$cur_datetime\n" >> /var/www/html/richstonedt_mirrors/centos/yum_6_update.log

exit 1

