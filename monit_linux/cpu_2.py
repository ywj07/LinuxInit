#!/usr/bin/python   
#-*- coding=utf-8 -*-

import os 
def load_stat(): 
    loadavg = {} 
    f = open("/proc/loadavg") 
    con = f.read().split() 
    f.close() 
    loadavg['lavg_1']=con[0] 
    loadavg['lavg_5']=con[1] 
    loadavg['lavg_15']=con[2] 
    loadavg['nr']=con[3] 
    loadavg['last_pid']=con[4] 
    return loadavg 
print "cpu load :过去15分钟的负载  "

print "loadavg",load_stat()['lavg_15']

