#!/bin/bash

#Author: yeweijie
#Time:2017-08-16 16:10:34
#Name:createusers_ops.sh
#Version:V1.0
#Description:用于---- 创建运维组用户,若用户存在，也可以用于修改用户密码，以及修改用户所属组


# 定义用户路径，若不存在则创建
DIR=/home/users
[ -d ${DIR} ] || mkdir  -p  ${DIR}

# 定义用户列表
userfile="${PWD}/userlist_ops"

# 新增用户组，创建组
group=ops
groupadd $group
#usermod -a -G $group $user # 将用户归属到组中的命令

# 定义新增用户的密码
password="Richstone123!"

# 判断是否存在相应的用户列表文件，没有则提示创建并退出脚本
user_list(){

if  [ ! -f ${userfile} ] 
    then  printf "请先创建用户列表文件 userlist_ops ： ${userfile} "
    exit 1
fi
return 0
}


# 读取用户列表，并根据定义好的组、密码进行用户创建以及用户权限修改
user_add(){
userlist=($(cat ${userfile}))
for user in ${userlist[*]}
do
        useradd -d ${DIR}/$user -g $group $user
        #读取用户并分配相应用户名的密码
        echo ""
        echo "${password}" | passwd --stdin $user
        # 若用户已存在，以下命令用户修改该用户的组属性 
        usermod -g  $group $user
        printf  ”查看用户是否创建，是否在指定目录“
        echo ""
        ls -lh ${DIR} |grep $user
        echo -e "\n"
        printf "用户：$user 配置成功 "
        echo -e "\n"
done
}



function main(){
# 判断是否存在用户列表，否则退出
user_list

user_add

}

# 执行main
####################################
main
####################################


