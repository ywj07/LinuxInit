#!/bin/bash

#Author: yeweijie
#Time:2017-08-14 11:07:49
#Name:user_add_group_mod.sh
#Version:V1.1
#Description:用于-内部openLDAP增加用户以及修改用户组
# V1.1: 增加了用户部门分组的新属性，该属性非空，若非研发部或产品部的新员工，以none定义。实际不配置用户部门信息。
# V1.1: 增加新增员工后，将新增用户姓名、部门信息存到当前目录的 useradd_info.txt 文件中
# V1.2: 增加中文名，uid数据输入


# 定义配置文件

addFile="/home/yunwei/ldif/staff.ldif"
modifyFile="/home/yunwei/ldif/modify.ldif"


# 定义全局变量，传入用户名以及部门信息
username=``
username_cn=``
deptinfo=``


# 取当前时间
cur_datetime=`date +%Y%m%d_%H%M`

new_file(){
if [ -f "$addFile" ]; then
 rm -rf "$addFile"
else
 touch "$addFile"
fi

if [ -f "$modifyFile" ]; then
 rm -rf "$modifyFile"
else
 touch "$modifyFile"
fi

}

get_username_cn(){
    printf "请输入用户的中文姓名：\n"
    # 计算获取字符串的长度并进行判断
    read username_cn
    Length=$(/bin/echo  $username_cn |wc -L)
    if [ "${Length}" = "0" ]
        then
            printf "\n-------请确认输入用户信息--------\n"
            get_username_cn
    else
        echo "你输入的用户名为：${username_cn}"
    fi
    #echo  "使用 ${username_cn} 进行用户新增"
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
    echo  "使用 ${username} 进行用户新增"
}

#获取用户的uid,其中userid.txt用于存储之前录入过的uid信息
get_useruid(){

user_id=($(awk '{print $1}' userid.txt))
linlen=`echo |awk 'END{print NR}' userid.txt`;

max=${user_id[0]}
for((i=1;i<$linlen;i++))
do
if [ ${user_id[$i]} -gt $max ];then max=${user_id[$i]};fi
done
uuid=$(($max+1))
echo $uuid >> userid.txt

}

add_user_file(){


cat >> ${addFile}  << EOF
dn: uid=${username},ou=fs-staff,ou=userAccount,dc=ldap,dc=richstonedt,dc=com
uid: ${username}
cn: ${username}
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: top
loginShell: /bin/bash
uidNumber: $uuid
gidNumber: 20001
sn: ${username}
mail: ${username}@richstonedt.com
homeDirectory: /home/${username}
userPassword: 123456
displayName: ${username_cn}
pwdReset: TRUE

EOF
}


get_deptinfo(){
    printf "请输入用户所属部门的英文简称：\n"
    printf "例如研发部：rd\n"
    printf "例如产品部：product\n"
    printf "非研发、产品部的同事请输入： none\n"
#   计算获取字符串的长度并进行判断
    read deptinfo
#    Length=$(/bin/echo  $username |wc -L)

    if  (  [ "${deptinfo}" = "rd" ] || [ "${deptinfo}" = "product" ] || [ "${deptinfo}" = "none" ] )
        then
            printf "输入的部门为： ${deptinfo} "
            printf "\n----------------------------\n"   
    else       
            printf "\n----请输入符合要求的部门信息：rd、product或none --------- \n"
            get_deptinfo
    fi

}

add_user_dept_file(){
    if [ "${deptinfo}" = "rd" ]
        then
            printf "\n----加入研发部---------\n"
            add_rd_dept_file
            printf  "已将用户 ${username}加入到 ${deptinfo} 部门中\n"
            printf  "\n------------------------------------------- \n "
    fi

    if [ "${deptinfo}" = "product" ]    
        then
            printf "\n----加入产品部----------\n"
            add_product_dept_file
            printf  "已将用户 ${username}加入到 ${deptinfo} 部门中\n"
            printf  "\n------------------------------------------- \n "

    fi

    if [ "${deptinfo}" = "none" ]
        then
            add_user_none_group_file            
            printf "\n----不配置部门dn----------\n"

    fi 


}

add_rd_dept_file(){
    printf "加入研发部所属的dn \n"
cat >> ${modifyFile} << EOF
dn:cn=richstonedt-rd-department,ou=Atlassian,ou=appGroup,dc=ldap,dc=richstonedt,dc=com
changetype: modify
add: member
member: uid=${username},ou=fs-staff,ou=userAccount,dc=ldap,dc=richstonedt,dc=com

EOF

}


add_product_dept_file(){
    printf "加入产品部所属的dn \n"
cat >> ${modifyFile} << EOF
dn:cn=richstonedt-product-department,ou=Atlassian,ou=appGroup,dc=ldap,dc=richstonedt,dc=com
changetype: modify
add: member
member: uid=${username},ou=fs-staff,ou=userAccount,dc=ldap,dc=richstonedt,dc=com

EOF

}


add_user_none_group_file(){
    printf "该用户暂不配置部门分组 \n"
    sleep 3
}


add_user_jira_file(){
    printf "加入Jira所属的dn \n"    
# 修改配置文件 /home/openldap/modify.ldif 

cat >> ${modifyFile} << EOF
dn:cn=jira-software-users,ou=Atlassian,ou=appGroup,dc=ldap,dc=richstonedt,dc=com
changetype: modify
add: member
member: uid=${username},ou=fs-staff,ou=userAccount,dc=ldap,dc=richstonedt,dc=com

EOF
}


add_user_confluence_file(){
    printf "加入confluence所属的dn \n"
cat >> ${modifyFile} << EOF
dn:cn=confluence-users,ou=Atlassian,ou=appGroup,dc=ldap,dc=richstonedt,dc=com
changetype: modify
add: member
member: uid=${username},ou=fs-staff,ou=userAccount,dc=ldap,dc=richstonedt,dc=com

EOF

} 


add_ldap(){
printf "开始导入配置文件"
echo ""
/usr/bin/ldapadd -h 192.168.6.28 -x -D "cn=Manager,dc=ldap,dc=richstonedt,dc=com" -w dtage520 -f ${addFile}
# /home/openldap/staff.ldif
/usr/bin/ldapmodify -h 192.168.6.28 -x -D "cn=Manager,dc=ldap,dc=richstonedt,dc=com" -w dtage520 -f ${modifyFile}
#/home/openldap/modify.ldif

# 打印新增用户的信息，记录时间信息
add_info_txt

}

add_info_txt(){
    # 打印新增用户的信息，记录时间信息
    echo -e "当前时间：${cur_datetime} \n 新增用户： ${username} ，所属部门：${deptinfo}\n\n "  >>  $PWD/useradd_info.txt
    tail -4 $PWD/useradd_info.txt

}

function main(){
# 调用函数：用于判断新增用户以及修改用户的文件是否存在，删除并重建
    printf "创建文件"
    new_file

#  获取用户名，中文简称
    printf  "获取用户名信息函数\n"
    get_username_cn
    get_username 
    printf "\n\n--------------获取的username为:  $username \n"

#  获取用户的uid
    printf  "获取用户uid信息函数\n"
    get_useruid
    printf "\n\n--------------获取的username为:  $uuid \n"

#  获取用户所属的部分信息
    get_deptinfo

# 配置新增用户文件
    add_user_file

# 配置用户所属组的文件
    add_user_dept_file
    add_user_jira_file
    add_user_confluence_file

    
# 执行ldap命令，将配置文件导入账号系统
    add_ldap

}

# 执行main
main
