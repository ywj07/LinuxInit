#!/bin/bash 

# by yeweijie
# 2017-06-14



mkdir -p ~/.pip          # 使用豆瓣pip源
#vim ~/.pip/pip.conf
echo -e "[global]\n" >> ~/.pip/pip.conf
# 清华的源比豆瓣的源快很多
echo -e "index-url = https://pypi.tuna.tsinghua.edu.cn/simple/   \n " >> ~/.pip/pip.conf
yum -y  install  python-pip
pip install --upgrade pip

echo "配置pip完成"
