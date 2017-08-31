#!/usr/bin/python
# -*- coding=utf-8 -*-

import pprint
import sys
import os 
def  get_ntp_server():

#    print ("请输入本地ntp服务器的ip :")
#    ntp_server= raw_input()
#    print "服务器ip:%s" % (ntp_server)
#    os.system('/usr/sbin/ntpdate -u %(ntp_server)')
# 本地ntp-server选用6.63
    os.system('ntpdate -u 192.168.6.63')
def main():
    print ("本地时钟同步设置")
    get_ntp_server()


if __name__ == '__main__':
    main()
