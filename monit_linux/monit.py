#!/usr/bin/python
#-*-coding=utf-8-*-

import os
import re
import smtplib
import datetime
import shelve
from email.mime.text import MIMEText

# 硬盘使用率报警阀值
hd_usage_rate_threshold = 50

# 要发给谁
mailto_list=["******@17guagua.com","******@17guagua.com"]

# 设置服务器，用户名、口令以及邮箱的后缀
mail_host="smtp.17guagua.com"
mail_user="******@17guagua.com"
mail_pass="******"
mail_postfix="17guagua.com"

# 日志偏移
log_offset = shelve.open('log_offset')

# 取当天日期
log_path_suffix=(datetime.date.today()).strftime('%Y-%m-%d')

# 当前日期key
cur_time = 'cur_time'

# 日志路径
app_info = {}
app_info['event'] = ['/home/ywj_git/event-ext-'+log_path_suffix+'.log',['失败','异常'],[]]

# 处理日志
def analysis_log(appName ,appInfo):
    cur_time_val = get_shelve_value(cur_time)
    if cur_time_val == -1:
        set_shelve_value(cur_time, log_path_suffix)
    elif log_path_suffix != cur_time_val:
        set_shelve_value(appName, 0)
        set_shelve_value(cur_time, log_path_suffix)

    f1 = file(appInfo[0], "r")
    offset = get_shelve_value(appName)
    if offset != -1:
        f1.seek(offset,1)
    else:
        set_shelve_value(appName, 0)
    count = 0
    exceptionStr = ""
    for s in f1.readlines():
        searchKey = appInfo[1]
        if len(searchKey) > 0:
            for i in searchKey:
                li = re.findall(i, s)
                if len(li) > 0:
                    count = count + li.count(i)
                    exceptionStr = exceptionStr + " " + s
        else:
            li = re.findall('Exception', s)
            if len(li) > 0:
                count = count + li.count('Exception')
                exceptionStr = exceptionStr + " " + s
    set_shelve_value(appName, f1.tell())
    print appName + " 异常数量为 " + str(count)
    return [count, "---------------------------------" + appName + " ----------------------------- \n " + exceptionStr]

#shelve 处理
def set_shelve_value(key, value):
    log_offset[key] = value

def get_shelve_value(key):
    if log_offset.has_key(key):
        return log_offset[key]
    else:
        return -1

def del_shelve_value(key):
    if log_offset.has_key(key):
        del log_offset[key]

# 发送邮件
def send_mail(to_list,sub,content):
  me = mail_user + "<"+ mail_user + "@" + mail_postfix + ">"
  msg = MIMEText(content, 'html', 'utf-8')
  msg['Subject'] = sub
  msg['From'] = me
  msg['To'] = ";".join(to_list)
  try:
    s = smtplib.SMTP()
    s.connect(mail_host)
    s.login(mail_user,mail_pass)
    s.sendmail(me, to_list, msg.as_string())
    s.close()
    return True
  except Exception, e:
    print str(e)
    return False

# 获得外网ip
def get_wan_ip():
    cmd_get_ip = "/sbin/ifconfig |grep 'inet addr'|awk -F\: '{print $2}'|awk '{print $1}' | grep -v '^127' | grep -v '192'"
    get_ip_info = os.popen(cmd_get_ip).readline().strip()
    return get_ip_info

# 检测硬盘使用
def check_hd_use():
        cmd_get_hd_use = '/bin/df'
        try:
            fp = os.popen(cmd_get_hd_use)
        except:
            ErrorInfo = r'get_hd_use_error'
            print ErrorInfo
            return ErrorInfo
        re_obj = re.compile(r'^/dev/.+\s+(?P<used>\d+)%\s+(?P<mount>.+)')
        hd_use = {}
        for line in fp:
            match = re_obj.search(line)
            if match is not None:
                hd_use[match.groupdict()['mount']] = match.groupdict()['used']
        fp.close()
        print hd_use
        return  hd_use

# 硬盘使用报警
def hd_use_alarm():
    for v in check_hd_use().values():
        if int(v) > hd_usage_rate_threshold:
            if send_mail(mailto_list,
                 'System Disk Monitor',
                 'nSystem Ip:%s\nSystem Disk Use:%s'
                 % (get_wan_ip(),check_hd_use())):
                 print  "sendmail success!!!!!"
        else:
             print "disk not mail"

if __name__ == '__main__':
  hd_use_alarm()
  exceptionCount = 0
  exceptionContents = "";
  for key in app_info:
    exceptionContent = analysis_log(key, app_info[key])
    exceptionCount += exceptionContent[0]
    exceptionContents += exceptionContent[1]
    exceptionContents = exceptionContents + "*********************************************** \n"

  print exceptionCount
#  if exceptionCount > 0:
#    if send_mail(mailto_list, get_wan_ip() + " 日志报警",exceptionContents):
#        print "发送成功"
#    else:
#        print "发送失败"



