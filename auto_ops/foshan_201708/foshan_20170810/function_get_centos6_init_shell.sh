#!/bin/bash

# by yeweijie
# 2017-08-09


cur_datetime=`date +%Y%m%d_%H%M`
DIR=/home/linux_init
mkdir $DIR

# 系统初始化，更新源配置，安装工具等
linux_init(){
cd $DIR
wget http://192.168.5.109/init/local_linux_init.sh
bash local_linux_init.sh
}




finish(){
echo -e "\n\n################"
echo "CentOS_6&hadoop 系统初始化完成～～"
echo -e "################\n\n"
sleep 5
}

main(){
# 更新本地镜像源
linux_init

# 打印完成任务的信息
finish

}

# 调用main
main


