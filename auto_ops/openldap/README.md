# openldap安装/初始化配置

>  创建于：2017-08-22

>  杨灵

## openldap server 安装
执行openldap_server_setup.sh，需要配置server的FQDN信息

## openldap reload
修改slapd.conf文件配置后需要进行openldap reload才能生效，执行openldap_ldapdb_reload.sh

## 增加GROUP MEMBER attribute
执行openldap_memberof.sh，安装完后默认GROUP是没有MEMBER attribut，需要手动添加，否则后续用户无法加入GROUP中。

## 设置密码策略
执行openldap_ppolicy.sh，包括密码策略模块的加载及添加默认的密码策略
执行openldap_pw_audit.sh，增加密码审计功能

## 设置sudo功能
执行openldap_sudo.sh，增加sudo模块
执行openldap_add_sudo.sh，增加默认的sudo权限为ALL

## 设置主机控制功能
执行openldap_host_deny.sh，增加主机控制模块，并添加主机默认的ou=servers

## 载入历史数据
执行openldap_load_user.sh，可根据最新的用户及组属性加载历史数据到ldif文件中

## 添加用户脚本
执行user_add_group_mod.sh，可添加用户到ldap server中

## 删除用户脚本
执行user_del_group_mod.sh，可把用户从ldap server中删除

## linux ldpa client安装/初始化配置
执行openldap_clent_setup.sh可进行linux centos 6.x ldap client设置。

