#!/bin/bash
basedn="dc=ldap,dc=richstonedt,dc=com"
binddn="cn=Manager,$basedn"
slapdpw=$1

if [ ! -n "$1" ];then
echo "Please input the ldapserver password after the script,like ./xx.sh password!"
exit
fi

function load_module_list() {
##定义olcModuleList对象
cat << EOF | ldapadd -Y EXTERNAL -H ldapi:///
dn: cn=module,cn=config
objectClass: olcModuleList
cn: module
EOF
##添加模块路径/usr/lib64/openldap/
cat << EOF | ldapadd -Y EXTERNAL -H ldapi:///
dn: cn=module{0},cn=config
changetype: modify
add: olcModulePath
olcModulePath: /usr/lib64/openldap/
EOF
}

function host_control(){
##定义主机控制模块
cat << EOF | ldapmodify -Y EXTERNAL -H ldapi:///
dn: cn=module{0},cn=config
changetype: modify
add: olcModuleLoad
olcModuleLoad: dynlist.la
EOF
##定义主机objectclass对象
cat << EOF | ldapadd -Y EXTERNAL -H ldapi:///
dn: olcOverlay=dynlist,olcDatabase={2}bdb,cn=config
objectClass: olcOverlayConfig
objectClass: olcDynamicList
olcOverlay: dynlist
olcDlAttrSet: inetOrgPerson labeledURI
EOF
##定义ldapns的schema
cat << EOF | ldapadd -Y EXTERNAL -H ldapi:///
dn: cn=ldapns,cn=schema,cn=config
objectClass: olcSchemaConfig
cn: ldapns
olcAttributeTypes: {0}( 1.3.6.1.4.1.5322.17.2.1 NAME 'authorizedService' DESC 'IANA GSS-API authorized service name' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )
olcAttributeTypes: {1}( 1.3.6.1.4.1.5322.17.2.2 NAME 'loginStatus' DESC 'Currently logged in sessions for a user' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch ORDERING caseIgnoreOrderingMatch SYNTAX OMsDirectoryString )
olcObjectClasses: {0}( 1.3.6.1.4.1.5322.17.1.1 NAME 'authorizedServiceObject' DESC 'Auxiliary object class for adding authorizedService attribute' SUP top AUXILIARY MAY authorizedService )
olcObjectClasses: {1}( 1.3.6.1.4.1.5322.17.1.2 NAME 'hostObject' DESC 'Auxiliary object class for adding host attribute' SUP top AUXILIARY MAY host )
olcObjectClasses: {2}( 1.3.6.1.4.1.5322.17.1.3 NAME 'loginStatusObject' DESC 'Auxiliary object class for login status attribute' SUP top AUXILIARY MAY loginStatus )
EOF
}

##定义主机组
function host_group(){
cat << EOF | ldapadd -x -D $binddn -w $slapdpw
dn: ou=servers,$basedn
objectClass: organizationalUnit
ou: servers
EOF
}

load_module_list
host_control
host_group
