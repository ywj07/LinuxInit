#!/bin/bash 

# yewejie



# 修改系统环境变量
#cat >> /root/.bash_profile  << EOF
#echo "export JAVA_HOME=/usr/java/jdk1.7.0_67-cloudera/" >> /root/.bash_profile
echo "export PATH=/usr/java/jdk1.7.0_67-cloudera//bin:$PATH " >> /root/.bash_profile

#EOF
# 生效

source /root/.bash_profile
java -version
echo -e "JDK已配置成功\n"
sleep 3

