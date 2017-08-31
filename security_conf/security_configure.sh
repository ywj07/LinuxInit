#!/bin/bash 
# richstonedt-devops
# yeweijie 
# 20170321

#echo ""  >> 
echo "操作系统版本"
cat  /etc/centos-release
echo "本脚本使用于CentOS 6的操作系统"
 

echo "一、检查项名称：检查主机访问控制（IP限制）"
echo "all:172.13.:DENY" >>  /etc/hosts.deny 
echo "all:192.:allow "  >>  /etc/hosts.allow  
echo "all:172.16.:allow"  >>  /etc/hosts.allow 
echo "all:10.:allow "  >>  /etc/hosts.allow 

sleep 10

echo "二、检查项名称：检查用户缺省UMASK 修改为027  "
echo "备份相关文件"
cp -p /etc/profile /etc/profile_bak
cp -p /etc/csh.login /etc/csh.login_bak
cp -p /etc/csh.cshrc /etc/csh.cshrc_bak
cp -p /etc/bashrc /etc/bashrc_bak
cp -p /root/.bashrc /root/.bashrc_bak
cp -p /root/.cshrc /root/.cshrc_bak

echo "观察是否有备份文件"
ls -ltr  /etc/*_bak
sleep 3
ls -a ~/*_bak

sleep 5

echo "/etc/profile    ----将UMASK值修改为027"
sed -i "s/umask 022/umask 027/" /etc/profile
sleep 2 

echo "/etc/csh.cshrc    ----将UMASK值修改为027"
sed -i "s/umask 022/umask 027/"  /etc/csh.cshrc
sleep 2 

echo "/etc/bashrc      ----将UMASK值修改为027"
sed -i "s/umask 022/umask 027/"  /etc/bashrc  
sleep 2 

# 第三点：
echo "三、检查项名称：检查登录提示-是否设置ssh警告Banner"

echo "步骤1 执行如下命令创建ssh banner信息文件"
touch /etc/sshbanner
chown bin:bin /etc/sshbanner
chmod 644 /etc/sshbanner
echo " Authorized users only. All activity may be monitored and reported "   >> /etc/sshbanner
sleep  5


echo "步骤2 修改vi /etc/ssh/sshd_config文件，添加如下行："
echo "Banner /etc/sshbanner"  >>   /etc/ssh/sshd_config
sleep  10


echo "四、检查项名称：检查帐号文件权限设置"
echo "1、备份："
cp -p /etc/passwd /etc/passwd_bak
cp -p /etc/shadow /etc/shadow_bak
cp -p /etc/group /etc/group_bak

sleep 5

echo "2、修改权限："
chmod 0644 /etc/passwd
chmod 0400 /etc/shadow
chmod 0644 /etc/group

sleep 10

echo "五、检查项名称：检查口令生存周期要求"
echo "1、执行备份："
cp -p /etc/login.defs /etc/login.defs_bak
echo "2、修改策略设置："
echo "修改PASS_MIN_LEN的值为8"
sed -i "s/PASS_MIN_LEN 5/PASS_MIN_LEN 8/"  /etc/login.defs
echo "修改PASS_MAX_DAYS的值为90"
sed -i  "s/PASS_MAX_DAYS 99999/PASS_MAX_DAYS 90/" /etc/login.defs
sleep 10


echo "六、检查项名称：检查登录提示-是否设置登录成功后警告Banner "
echo " Authorized users only. All activity may be monitored and reported " >> /etc/motd

sleep 5


echo "七、检查项名称：检查是否限制root远程登录"
echo "1、执行备份"
cp -p /etc/securetty /etc/securetty_bak
cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config_bak

echo "2、创建临时用户:admin/admin123456并分配sudo权限"
useradd admin
echo "admin123456"  |passwd --stdin admin
echo "admin   ALL=(ALL)  ALL " >> /etc/sudoers 

# 不关闭root用户的远程登录，否则无法进行4A平台的扫描
#echo " 禁止root用户远程登录系统："
#sed -i  "s/#PermitRootLogin yes/PermitRootLogin no/"  /etc/ssh/sshd_config
#/etc/init.d/sshd restart
#sleep 10


echo "八、检查项名称：检查登录提示-更改ftp警告Banner "
echo "关于vsftpd的配置修改另外操作，如无安装则无需修改相关配置"
sleep 5



echo  "九、检查项名称：检查是否禁止icmp重定向"
echo "1、备份文件："
cp -p /etc/sysctl.conf /etc/sysctl.conf_bak

echo "2:执行相关命令:"
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -p
sleep 10

echo "十、检查项名称：检查是否禁止匿名ftp"
#1、编辑FTP配置文件
#vi /etc/vsftpd/vsftpd.conf
#在配置文件中添加行：
#anonymous_enable=NO
echo "关于vsftpd的配置修改另外操作，如无安装则无需修改相关配置"
sleep 5

echo "十一、检查项名称：检查FTP配置-限制FTP用户登录后能访问的目录"
#1、修改/etc/vsftpd.conf
#vi /etc/vsftpd/vsftpd.conf
#确保以下行未被注释掉，如果没有该行，请添加：
#chroot_local_user=YES


echo "关于vsftpd的配置修改另外操作，如无安装则无需修改相关配置"
sleep 5


echo "十二、检查项名称：检查FTP配置-设置FTP用户登录后对文件、目录的存取权限 "

echo "关于vsftpd的配置修改另外操作，如无安装则无需修改相关配置"
sleep 5


echo  " 十三、检查项名称：检查是否配置远程日志保存"
echo "1、执行备份： "
cp -p /etc/rsyslog.conf /etc/rsyslog.conf_bak
echo "*.*   @192.168.6.254"  >> /etc/rsyslog.conf
echo "3、重启syslog服务"
/etc/init.d/rsyslog restart
sleep 10



echo  "十四、检查项名称：检查是否设置登录超时"
echo "1、执行备份： "
cp -p /etc/profile  /etc/profile_bak

echo "清除TMOUT相关的配置："
sed -i "/TMOUT/d"  /etc/profile

echo "修改vi /etc/profile文件增加以下两行："
echo "TMOUT=599"  >> /etc/profile
echo "export TMOUT"  >> /etc/profile
sleep 3


echo "2、修改 vi /etc/csh.cshrc文件，添加如下行：" 
echo "set autologout=599"  >>  /etc/csh.cshrc
sleep 10



echo " 十五、检查项名称：检查口令重复次数限制 "
echo "1、执行备份："
cp -p /etc/pam.d/system-auth /etc/pam.d/system-auth_bak
sleep 2
echo "2、创建文件/etc/security/opasswd，并设置权限（执行以下命令）"
touch /etc/security/opasswd
chown root:root /etc/security/opasswd
chmod 600 /etc/security/opasswd
sleep 2
echo "3、修改策略设置："
echo "在password sufficient pam_unix.so sha512 shadow nullok try_first_pass use_authtok所在行
后面增加remember=5，保存退出；"
sed -i "s/use_authtok/use_authtok remember=5/"   /etc/pam.d/system-auth

sleep 10

echo "十六、检查口令锁定策略"

echo "1、修改策略设置："
sed  -i '/pam_env.so/a\auth        required      pam_tally2.so deny=6 onerr=fail no_magic_root unlock_time=120' /etc/pam.d/system-auth
sleep 5

echo  "安全合规配置初始化完成！"



