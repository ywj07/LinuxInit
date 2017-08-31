# 本地镜像源配置


> Author: yeweijie

> Time:2017-08-16 10:59:43

> Name:readme.md

> Version:V1.0



## 本地镜像源信息

*  服务器IP：192.168.6.114
*  URL：http://192.168.6.114/

## 本地镜像服务器在凌晨与网络进行同步

*  公司内部使用可以将所有服务器的yum更新为该服务器地址
*  项目上使用可以用于服务器的版本升级用于解决漏洞问题


## crontab 配置定时任务
```
# 对镜像源与本地源进行同步
0  1 * * * /bin/bash  /var/www/html/richstonedt_mirrors/centos/centos_6_auto_update_yum.sh
20 1 * * * /bin/bash  /var/www/html/richstonedt_mirrors/centos/centos_7_auto_update_yum.sh
40 1 * * * /bin/bash  /var/www/html/richstonedt_mirrors/ELK/centos_auto_update_elk.sh
55 1 * * * /bin/bash  /var/www/html/richstonedt_mirrors/docker/centos_auto_update_docker.sh
10 2 * * * /bin/bash  /var/www/html/richstonedt_mirrors/epel/centos_auto_update_epel_6.sh
35 2 * * * /bin/bash  /var/www/html/richstonedt_mirrors/epel/centos_auto_update_epel_7.sh
45 2 * * * /bin/bash  /var/www/html/richstonedt_mirrors/zabbix/centos_auto_update_zabbix.sh

```


## 更新本地yum环境
```
yum clean all
yum makecache
```
