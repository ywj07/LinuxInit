#!/bin/bash 


# by yeweijie
# 2017-08-09


# 定义集群名
CLUSTER=other
# 定义集群配置的脚本 gmond.conf_集群名
GMOND_CONF=install_gmond_centos_6_other.sh

# install_gmond_centos_6_cdh.sh
# install_gmond_centos_6_other.sh
# install_gmond_centos_6_pg.sh
# install_gmond_centos_6_web.sh

update_yum(){
# 对进行本地镜像源的更新配置
/usr/bin/ansible ${CLUSTER} -m command -a " rm -rf  /root/function_get_centos6_init_shell.sh" 
/usr/bin/ansible ${CLUSTER} -m command -a "wget http://192.168.5.109/init/function_get_centos6_init_shell.sh"

/usr/bin/ansible ${CLUSTER} -m shell -a "bash /root/function_get_centos6_init_shell.sh	"
}

gmond_conf(){
# 进行gmond配置文件的替换以及更新
/usr/bin/ansible  ${CLUSTER} -m command -a "wget http://192.168.5.109/gmond/${GMOND_CONF}"
/usr/bin/ansible  ${CLUSTER} -m shell -a "bash  /root/${GMOND_CONF}"
}


update_yum

gmond_conf
