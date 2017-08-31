本脚本以及安装包用于升级ssh /ssl

1: 为确保ssh安装时可能存在问题，开通telnet 访问服务器的功能
./init_telnet.sh

2: 新建窗口，通过telnet的方式登录该服务器

3: 开始升级 ssh/ssl 。执行脚本后开始编译安装，时间大约10-15分钟，视机器性能。
./update_sshssl.sh

