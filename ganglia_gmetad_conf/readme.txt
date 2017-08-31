# ganglia-web 替换文件

# by yeweijie
# 2017-04-25

1: 替换header.php 
原文件：/usr/local/apache/htdocs/ganglia/header.php

修改内容：

<?php
session_start();

//增加以下部分：
ini_set('date.timezone', 'PRC');
//添加，-修改时区为本地时区


2: 替换  inspect_graph.php

将inspect_graph.php备份
mv inspect_graph.php  inspect_graph.php_bak
将inspect_graph.php_noutc改为：inspect_graph.php
mv inspect_graph.php_noutc inspect_graph.php

修改内容：将内部的utcTime函数中的utc部分去掉

3: 本地服务器可能因为时间的修改而导致ganglia前端的图表收不到数据

解决方法很简单，就是把/var/lib/ganglia/rrds/目录下的内容全删掉
例如： rm  -rf  /var/lib/ganglia/rrds/* 
另外，也可以将该部分文件转移出该目录


4: 待补充
