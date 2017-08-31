#!/usr/bin/python
# -*- coding=utf-8 -*-


import os
import psutil

disk=os.statvfs('/')
print disk

percent=(disk.f_blocks-disk.f_bfree)*100/(disk.f_blocks-disk.f_bfree+disk.f_bavail)

print percent

limit = int(79)

if int(percent) > limit:
#    print ('磁盘利用率大于79%')
    print "利用率大于79%"



print psutil.disk_partitions()
print psutil.disk_usage('/boot')


