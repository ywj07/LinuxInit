#!/bin/bash
#ldapdb data reload
function ldapdb_reload(){
rm -rf /etc/openldap/slapd.d/*
slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d/
chown -R ldap.ldap /etc/openldap/slapd.d/
service slapd restart
}
#执行函数
ldapdb_reload
