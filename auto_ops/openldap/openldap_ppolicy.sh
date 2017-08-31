#!/bin/bash
slapconf_file=/etc/openldap/slapd.conf
basedn="dc=ldap,dc=richstonedt,dc=com"
binddn="cn=Manager,$basedn"
slapdpw=$1

if [ ! -n "$1" ];then
echo "Please input the ldapserver password after the script,like ./xx.sh password!"
exit
fi

#add password policy
function add_ppolicy(){
cat << EOF | ldapadd -Y EXTERNAL -H ldapi:///
dn: olcOverlay=ppolicy,olcDatabase={2}bdb,cn=config
changetype: add
objectClass: olcOverlayConfig
objectClass: olcPPolicyConfig
olcOverlay: ppolicy
olcPPolicyDefault: cn=default,ou=pwpolicies,$basedn
olcPPolicyHashCleartext: TRUE
olcPPolicyUseLockout: TRUE
EOF

##定义密码策略组
cat << EOF | ldapadd -x -D $binddn -w $slapdpw
dn: ou=pwpolicies,dc=richstonedt,dc=com
objectclass: organizationalUnit
ou: pwpolicies
EOF

cat << EOF | ldapadd -x -D $binddn -w $slapdpw
dn: cn=default,ou=pwpolicies,$basedn
cn: default
objectclass: pwdPolicy
objectclass: person
pwdAllowUserChange: TRUE
pwdAttribute: userPassword
pwdExpireWarning: 259200
pwdFailureCountInterval: 0
pwdGraceAuthNLimit: 3
pwdInHistory: 3
pwdLockout: TRUE
pwdLockoutDuration: 300
pwdMaxAge: 2592000
pwdMaxFailure: 5
pwdMinAge: 0
pwdMinLength: 8
pwdMustChange: TRUE
pwdSafeModify: TRUE
sn: dummy value
EOF
}

##加载ppolicy module
echo "moduleload ppolicy.la" >> $slapconf_file
echo "modulepath /usr/lib/openldap" >> $slapconf_file
echo "modulepath /usr/lib64/openldap" >> $slapconf_file

##增加用户可以修改密码的权限配置
sed -i '/if no access/i\access to attrs=shadowLastChange,userPassword\n        by self write\n        by * auth\naccess to *\n        by * read' $slapconf_file

#设置默认的密码策略
echo "overlay ppolicy" >> $slapconf_file
echo "ppolicy_default cn=default,ou=pwpolicies,$basedn" >> $slapconf_file

/bin/bash ./openldap_ldapdb_reload.sh

#执行函数
add_ppolicy
