#!/usr/bin/env python
# -*- coding=utf-8 -*-

# ./filename  打印同名且文件大小一样的不同子路径的文件名，时间

from __future__ import print_function
from operator import itemgetter  
import os
import time

'tt为浮点型日期，换化为年月日时分秒格式时间'
def timeYS(tt):
    t1 = time.localtime(tt)
    t2 = time.strftime("%Y-%m-%d %H:%M:%S",t1)
    return t2;  
        
class File():
    '''
    copy move remove
    '''
    allfilecount = 0
    rddfilecount = 0
    singlefiles={}
    rddfiles={}
    rdddirs={}

    def __init__(self):
        '''
        Constructor
        '''
    def getFileMsg(self,filepath):
        '''
        以元组(filepath,ftime,size)形式输出文件信息
        '''
        if os.path.isfile(filepath):
            size = os.path.getsize(filepath)  #bytes B 
            if size <= 1024:
                size ='{0}B'.format(size);
            elif size <= 1024*1024:
                size = size/1024
                size ='{0}K'.format(size);
            else:
                size = size/1024/1024
                size ='{0}M'.format(size);
            #filename = os.path.basename(filepath)
            
            ftime = timeYS(os.path.getmtime(filepath))
            return (filepath,ftime,size)
        return ()
    
    
    
    def setRedundanceFile(self,filepath):
        '''
        根据文件名称和大小判断文件是否重复,文件信息:元组(filepath,mtime,size) ,getFileMsg返回值
        1. 遍历某一目录下所有文件
        2. 将文件的名称及大小组成一个字符串，做为 key 放入字典 dict1 ,其 value 为 文件信息
        3. 每次放入时时判断 key 是否存在，若存在，就将 文件信息 放入字典 dict2
        4. dict2 的 key 为 文件名称，value为 文件信息 列表 list1
        '''
        try:
            if os.path.isdir(filepath):
                for fil in os.listdir(filepath):
                    fil = os.path.join(filepath,fil)
#                    print('当前路径以及文件名')
#                    print(fil)
                    self.setRedundanceFile(fil)
            elif os.path.isfile(filepath):
                self.allfilecount = self.allfilecount + 1
                size = os.path.getsize(filepath)  
                filename = os.path.basename(filepath)
                f = self.getFileMsg(filepath)
#                print (f)
#                print ('123')
#                print("f[0]")
#                print (f[0])
                filekey = '{0}_{1}'.format(filename, size)
                
                if self.singlefiles.has_key(filekey):
                    self.rddfilecount = self.rddfilecount + 1
                    
                    #增加规则：发现一个重复文件时，在父目录下文件数加1，若是首次发现则取该文件在总文件列表的父目录，其数目也加1
                    pardir = os.path.dirname(filepath)
                    if self.rdddirs.has_key(pardir):
                        self.rdddirs[pardir] = self.rdddirs.get(pardir)+1
                    else:
                        self.rdddirs[pardir] = 1
                    
                    
                    if self.rddfiles.has_key(filekey) :
                        self.rddfiles[filekey].append(f)
                    else:
                        self.rddfiles[filekey] = [f]
                        f = self.singlefiles.get(filekey)
                        self.rddfiles[filekey].append(f)
                        #若是首次发现则取该文件在总文件列表的父目录，其数目也加1
                        pardir = os.path.dirname(f[0])
#                        print ("pardir")
#                        print (pardir)
                        if self.rdddirs.has_key(pardir):
                            self.rdddirs[pardir] = self.rdddirs.get(pardir)+1
                        else:
                            self.rdddirs[pardir] = 1
                        
                        
                else:
                    self.singlefiles[filekey]=f
                    
            else:
                return
                    
        except Exception as e:
            print(e)
        
    
    def showFileCount(self):
        print(self.allfilecount)
    
    def showRedundanceFile(self,filepath):
        '''
        根据文件名称和大小判断文件是否重复
        '''
        self.allfilecount = 0
        self.rddfilecount = 0
        self.singlefiles={}
        self.rddfiles={}
        
        
        
        self.setRedundanceFile(filepath)
        print('the total file num:{0},the redundance file num(not including the first file):{1}'.format(self.allfilecount,self.rddfilecount))
        print('-----------------------------------------')
        for k in self.rddfiles.keys():
            for l in sorted(self.rddfiles.get(k), key=itemgetter(1)): #按修改日期升序排列
#                print ("l[0]");
                print ("打印路径")
                print (l[0]);
                print (l[1],l[2]);
#                print (l);
            print('#######\n\n\n');
        print('------------------------------------------')
        
        
        
    def showCanRemoveFile(self,filepath):
        '''
        根据文件名称和大小判断文件是否重复
        输出按修改时间较旧的文件
        '''
        self.allfilecount = 0
        self.rddfilecount = 0
        self.singlefiles={}
        self.rddfiles={}
        rmlist = []
        self.setRedundanceFile(filepath)
        
        for k in self.rddfiles.keys():
            tmplist = sorted(self.rddfiles.get(k), key=itemgetter(1))
            tmplist.pop()
            rmlist.extend(tmplist)
        for rl in rmlist:
            print(rl[0])
        
    def rdddirstat(self):  
        '''
        按目录统计文件重复个数
        输出：目录/tmp  重复个数5，是指/tmp目录下有5个文件在其他地方也存在
        
        '''
        if len(self.rdddirs)> 0 :
            print('The redundance file statistics by dirs:')
            for rd in self.rdddirs.keys():
                print('{0} {1}'.format(rd, self.rdddirs.get(rd)))
        else:
            print('There are no redundance files')
        
if __name__ == '__main__':
    f = File()
    filepath = os.getcwd()
    #filepath = '/scripts'
    
    f.showRedundanceFile(filepath) #查看多余的文件
    #f.showCanRemoveFile(filepath)  #按修改时间给出比较旧的多余文件
    f.rdddirstat()                 #按目录统计重复文件个数

