#!/bin/bash
slapconf_file=/etc/openldap/slapd.conf


if [ ! -n "$1" ];then
echo "Please input the ldapserver password after the script,like ./xx.sh password!"
exit
fi

#1. setuphostname
host_ip=`ifconfig | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | head -n 1`
hostname1=ldap
hostname2=richstonedt
hostname3=com
echo "$host_ip $hostname1$hostname2$hostname3" >> /etc/hosts

#2. install env
#install wget
#yum install -y wget
#install epel source
#wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
#install openldap
yum install -y openldap openldap-servers openldap-clients openldap-devel compat-openldap rsyslog monit

#3. openldap setup
#3.1 log setup
mkdir -p /var/log/slapd
chmod 755 /var/log/slapd/
chown ldap:ldap /var/log/slapd/
sed -i "/local4.*/d" /etc/rsyslog.conf
cat >> /etc/rsyslog.conf << EOF
local4.*                        /var/log/slapd/slapd.log
EOF
service rsyslog restart

#3.2 setup slapd password
basedn="dc=$hostname1,dc=$hostname2,dc=$hostname3"
binddn="cn=Manager,$basedn"
slapdpw=$1
echo $slapdpw |slappasswd -stdin
cp /usr/share/openldap-servers/slapd.conf.obsolete $slapconf_file
sed -i '/rootpw/i\rootpw          '$slapdpw'' $slapconf_file
sed -i 's/dc=my-domain/dc='$hostname1',dc='$hostname2'/g' $slapconf_file
echo "loglevel 257" >> $slapconf_file
chown ldap.ldap $slapconf_file

#3.3 setup openldap DB
cp /usr/share/openldap-servers/DB_CONFIG.example  /var/lib/ldap/DB_CONFIG
chown -R ldap.ldap /var/lib/ldap
service slapd start

#3.4 ldapdb data reload
/bin/bash ./openldap_ldapdb_reload.sh
