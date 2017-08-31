#!/bin/bas
hostname1=richstonedt
basedn="dc=ldap,dc=richstonedt,dc=com"
binddn="cn=Manager,$basedn"
slapdpw=$1

if [ ! -n "$1" ];then
echo "Please input the ldapserver password after the script,like ./xx.sh password!"
exit
fi

#add base dn to ldapserver
cat << EOF | ldapadd -x -D $binddn -w $slapdpw
dn: $basedn
dc: ldap
objectclass: top
objectclass: domain
EOF

#add People Group to ldapserver
cat << EOF | ldapadd -x -D $binddn -w $slapdpw
dn: ou=userAccount,$basedn
ou: userAccount
objectclass: top
objectclass: organizationalUnit
EOF

cat << EOF | ldapadd -x -D $binddn -w $slapdpw
dn: ou=appGroup,$basedn
ou: appGroup
objectclass: top
objectclass: organizationalUnit
EOF

cat << EOF | ldapadd -x -D $binddn -w $slapdpw
dn: ou=linuxGroup,$basedn
ou: linuxGroup
objectclass: top
objectclass: organizationalUnit
EOF
