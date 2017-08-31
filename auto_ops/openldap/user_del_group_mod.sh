#!/bin/bash
# 定义配置文件
modifyFile="/home/yunwei/ldif/group_del.ldif"

# 定义全局变量，传入用户名以及部门信息
username=``
username_cn=``
deptinfo=``


# 取当前时间
cur_datetime=`date +%Y%m%d_%H%M`

new_file(){
if [ -f "$modifyFile" ]; then
 rm -rf "$modifyFile"
else
 touch "$modifyFile"
fi

}

get_username(){
    printf "请输入用户的中文姓名的拼音全称：\n"
    # 计算获取字符串的长度并进行判断
    read username
    Length=$(/bin/echo  $username |wc -L)
    if [ "${Length}" = "0" ]
        then
            printf "\n-------请确认输入用户信息--------\n"
            get_username
    else
        echo "你输入的用户名为：${username}"
    fi
    echo  "即将删除 ${username} 用户"
}

get_deptinfo(){
    printf "请输入用户所属部门的英文简称：\n"
    printf "例如研发部：rd\n"
    printf "例如产品部：product\n"
    printf "非研发、产品部的同事请输入： none\n"
#   计算获取字符串的长度并进行判断
    read deptinfo
    if  (  [ "${deptinfo}" = "rd" ] || [ "${deptinfo}" = "product" ] || [ "${deptinfo}" = "none" ] )
        then
            printf "输入的部门为： ${deptinfo} "
            printf "\n----------------------------\n"
    else
            printf "\n----请输入符合要求的部门信息：rd、product或none --------- \n"
            get_deptinfo
    fi

}

del_user_dept_file(){
    if [ "${deptinfo}" = "rd" ]
        then
            del_rd_dept_file            
    fi

    if [ "${deptinfo}" = "product" ]    
        then
            del_product_dept_file
    fi

    if [ "${deptinfo}" = "none" ]
        then
            del_user_none_group_file           
    fi 
}


del_rd_dept_file(){

cat >> ${modifyFile} << EOF
dn:cn=richstonedt-rd-department,ou=Atlassian,ou=appGroup,dc=ldap,dc=richstonedt,dc=com
changetype: modify
delete: member
member: uid=${username},ou=fs-staff,ou=userAccount,dc=ldap,dc=richstonedt,dc=com

EOF

}

del_product_dept_file(){

cat >> ${modifyFile} << EOF
dn:cn=richstonedt-product-department,ou=Atlassian,ou=appGroup,dc=ldap,dc=richstonedt,dc=com
changetype: modify
delete: member
member: uid=${username},ou=fs-staff,ou=userAccount,dc=ldap,dc=richstonedt,dc=com

EOF

}

del_user_jira_file(){

cat >> ${modifyFile} << EOF
dn:cn=jira-software-users,ou=Atlassian,ou=appGroup,dc=ldap,dc=richstonedt,dc=com
changetype: modify
delete: member
member: uid=${username},ou=fs-staff,ou=userAccount,dc=ldap,dc=richstonedt,dc=com

EOF
}


del_user_confluence_file(){

cat >> ${modifyFile} << EOF
dn:cn=confluence-users,ou=Atlassian,ou=appGroup,dc=ldap,dc=richstonedt,dc=com
changetype: modify
delete: member
member: uid=${username},ou=fs-staff,ou=userAccount,dc=ldap,dc=richstonedt,dc=com

EOF

}

del_user_none_group_file(){
    sleep 3
}

del_ldap(){
printf "开始删除用户信息"
echo ""
/usr/bin/ldapdelete -h 192.168.6.28 -x -D "cn=Manager,dc=ldap,dc=richstonedt,dc=com" -w dtage520 uid=${username},ou=fs-staff,ou=userAccount,dc=ldap,dc=richstonedt,dc=com
printf "开始删除用户所属组信息"
echo ""
/usr/bin/ldapmodify -h 192.168.6.28 -x -D "cn=Manager,dc=ldap,dc=richstonedt,dc=com" -w dtage520 -f ${modifyFile}

# 打印删除用户的信息，记录时间信息
del_info_txt
}

del_info_txt(){
    # 打印新增用户的信息，记录时间信息
    echo -e "当前时间：${cur_datetime} \n 删除用户： ${username} ，所属部门：${deptinfo}\n\n "  >>  $PWD/useradd_info.txt
    tail -4 $PWD/useradd_info.txt
}

function main(){
# 调用函数：用于判断新增用户以及修改用户的文件是否存在，删除并重建
    printf "创建文件"
    new_file

#  获取用户名，中文简称
    printf  "获取用户名信息函数\n"
    get_username 
    printf "\n\n--------------获取的username为:  $username \n"

#  获取用户所属的部分信息
    get_deptinfo

# 配置用户所属组的文件
    del_user_dept_file
    del_user_jira_file
    del_user_confluence_file
    
# 执行ldap命令，将配置文件导入账号系统
    del_ldap
}

# 执行main
main
