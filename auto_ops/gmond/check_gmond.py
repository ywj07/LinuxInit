#!/usr/bin/python 
#-*- coding=utf-8 -*-
import os, sys, time 
 
#while True: 
#    time.sleep(4) 

try: 
    ret = os.popen('ps -C gmond -o pid,cmd').readlines() 
    print "ret:"
    print ret    
    if len(ret) < 2: 
        print "gmond  进程异常退出， 4 秒后重新启动" 
        time.sleep(3) 
        os.system("service gmond restart") 
        ret2 = os.popen('ps -C gmond -o pid,cmd').readlines()
        print "ret2:"
        print ret2[-2]
        print ret2[-1] 
except: 
    print "Error", sys.exc_info()[1]
