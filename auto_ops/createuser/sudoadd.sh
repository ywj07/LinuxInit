#!/bin/bash



# 将某一用户组 加入到sudo权限的配置
echo "%dev        ALL=(ALL)       ALL"  >> /etc/sudoers
echo "%ops        ALL=(ALL)       ALL"  >> /etc/sudoers

