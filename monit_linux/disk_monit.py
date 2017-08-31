#!/usr/bin/python
import re
import os
def getAllitems(host,oid):
        sn1 = os.popen('snmpwalk -v 2c -c public ' + host + ' ' + oid).read().split('\n')[:-1]
        return sn1
                                                             
def getDate(source,newitem):
        for item in source[5:]:
                newitem.append(item.split(':')[3].strip())
        return newitem
                                                             
def getRealDate(item1,item2,listname):
        for i in range(len(item1)):
                listname.append(int(item1[i])*int(item2[i])/1024)
        return listname
                                                             
def caculateDiskUsedRate(host):
        hrStorageDescr = getAllitems(host, 'HOST-RESOURCES-MIB::hrStorageDescr')
        hrStorageUsed = getAllitems(host, 'HOST-RESOURCES-MIB::hrStorageUsed')
        hrStorageSize = getAllitems(host, 'HOST-RESOURCES-MIB::hrStorageSize')
        hrStorageAllocationUnits = getAllitems(host, 'HOST-RESOURCES-MIB::hrStorageAllocationUnits')
                                                             
        disk_list = []
        hrsused = []
        hrsize = []
        hrsaunits = []
                                                             
        #get disk_list
        for item in hrStorageDescr:
                if re.search('/',item):
                        disk_list.append(item.split(':')[3])
        #print disk_list      
                                                             
        getDate(hrStorageUsed,hrsused)
        getDate(hrStorageSize,hrsize)
        #print getDate(hrStorageAllocationUnits,hrsaunits)
                                                             
        #get hrstorageAllocationUnits
        for item in hrStorageAllocationUnits[5:]:
                hrsaunits.append(item.split(':')[3].strip().split(' ')[0])
        #caculate the result
        #disk_used = hrStorageUsed * hrStorageAllocationUnits /1024 (KB)
        disk_used = []
        total_size = []
        disk_used = getRealDate(hrsused,hrsaunits,disk_used)
        total_size = getRealDate(hrsize,hrsaunits,total_size)
                                                             
        diskused_rate = []
        for i in range(len(disk_used)):
                diskused_rate.append(str(round((float(disk_used[i])/float(total_size[i])*100), 2)) + '%')
                                                             
        return diskused_rate,disk_list
                                                             
if __name__ == '__main__':
        hosts = ['127.0.0.1','192.168.6.184']
        for host in hosts:
                result = caculateDiskUsedRate(host)
                diskused_rate = result[0]
                partition = result[1]
                print "==========",host,'=========='
                for i in range(len(diskused_rate)):
                        print '%-20s used: %s' % (partition[i],diskused_rate[i])
                print

