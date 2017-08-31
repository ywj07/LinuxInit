#!/bin/bash
basedn="dc=ldap,dc=richstonedt,dc=com"
binddn="cn=Manager,$basedn"
slappw=$1

if [ ! -n "$1" ];then
echo "Please input the ldapserver password after the script,like ./xx.sh password!"
exit
fi

function addsudoers(){
cat << EOF | ldapadd -x -D $binddn -w $slappw
dn: ou=sudoers,$basedn
ObjectClass: organizationalUnit
ou: sudoers

dn: cn=defaults,ou=sudoers,$basedn
objectClass: sudoRole
cn: defaults
description: Default sudoOption's go here
sudoOption: requiretty
sudoOption: !visiblepw
sudoOption: always_set_home
sudoOption: env_reset
sudoOption: env_keep="COLORS DISPLAY HOSTNAME HISTSIZE INPTURC KDEDIR LS_COLORS"
sudoOption: env_keep+="MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"
sudoOption: env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"
sudoOption: env_keep+="LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"
sudoOption: secure_path=/sbin:/bin:/usr/sbin:/usr/bin
EOF
}

addsudoers
