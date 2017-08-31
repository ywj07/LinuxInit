#!/bin/bash

#Author: yeweijie
#Time:2017-08-15 17:30:48
#Name:function_get_centos6_init_shell.sh
#Version:V1.0
#Description:用于---- CentOS6 系统初始化

######################################################################
# http://192.168.6.184/linux_init/function_get_centos6_init_shell.sh
# bash  function_get_centos6_init_shell.sh
######################################################################

set -x 

# 获取系统当前时间
cur_datetime=`date +%Y%m%d_%H%M`

# 定义脚本路径
DIR=/home/init_script

# 判断是否存在该目录，没有则创建
[ ! -d ${DIR} ] &&  mkdir  ${DIR}


# 获取初始化系统的脚本
get_script(){
cd $DIR
mkdir bak 
mv *.sh  bak/
wget http://192.168.6.184/linux_init/local_linux_init.sh
wget http://192.168.6.184/gmond/install_gmond_centos_6.sh
wget http://192.168.6.184/jumpserver/add_jumpserver_user.sh
wget http://192.168.6.184/python/change_python_pip.sh
}


# 系统初始化，更新源配置，安装工具等
linux_init(){
cd $DIR
bash local_linux_init.sh
}


#  安装ganglia监控的客户端
install_gmond(){
cd  $DIR
bash  install_gmond_centos_6.sh
}


add_jumpserver_user(){
cd $DIR
bash add_jumpserver_user.sh
}


# 修改python pip以及升级pip
install_pip(){
cd $DIR
bash  change_python_pip.sh
}


finish(){
echo -e "\n\n################"
echo "CentOS_6 系统初始化完成～～"
echo -e "################\n\n"
sleep 5
}

function main(){

# 获取初始化系统的脚本
get_script

# 更新本地镜像源，安装基础工具
linux_init

# 安装和配置监控客户端
install_gmond

# 安装Python pip 并修改配置
install_pip

# 新增jumpserver系统用户
add_jumpserver_user

# 打印完成任务的信息
finish

}


################################
# 调用main
main
################################

