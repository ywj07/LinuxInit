#! /bin/bash 
# yeweijie
# 2017-02-23

echo "创建新目录"
/home/zs_sh/zs_mkdir.sh  

echo "对磁盘进行格式化"
/home/zs_sh/zs_mkfs.sh 
 
echo "挂载各分区到新建目录"
/home/zs_sh/zs_mount.sh

echo "修改文件系统表"
/home/zs_sh/zs_fstab.sh 


echo "磁盘挂载初始化完成"
