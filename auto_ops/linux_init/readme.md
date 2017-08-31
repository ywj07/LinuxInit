# CentOS 6的系统初始化配置

> 叶伟杰

> 2017-08

## 操作描述
*  对公司内部的linux系统（物理机/虚拟机）进行初始化
* 工作以自动化的脚本输出
1.  根据本地yum服务器的信息，对新增的linux进行yum配置的修改(/etc/yum.repos.d/) 内的repo文件
2.  配置操作日志记录
3.  配置监控客户端，与监控服务器的同步，添加gmond的进程监控
4.  配置其他性能监控工具:iftop,screen,glances
5.  配置jumpserver堡垒机用户
6.  配置python pip环境


## 执行方式

```
#执行方式

wget http://192.168.6.184/linux_init/function_get_centos6_init_shell.sh
bash function_get_centos6_init_shell.sh
```
