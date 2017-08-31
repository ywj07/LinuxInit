使用说明：
配置相应的用户列表：
这里定义了开发和运维的用户文件
userlist_dev
userlist_ops

执行脚本：区分开发和运维，分别对应不同用户列表
注意用户名设置为：姓名全拼且密码同用户账号
./createusers_dev.sh	
./createusers_ops.sh	


分配用户的sudo权限
这里可以执行脚本，将开发组和运维组加入到相应的配置文件。
./sudoadd.sh

