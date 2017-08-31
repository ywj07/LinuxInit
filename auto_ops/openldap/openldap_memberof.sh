#!/bin/bah
#add memberof module
function add_memberof() {
cat << EOF | ldapadd -Y EXTERNAL -H ldapi:///
dn: cn=module,cn=config
cn: module
objectClass: olcModuleList
objectclass: top
olcModuleLoad: memberof.la
olcModulePath: /usr/lib64/openldap

dn: olcOverlay=memberof,olcDatabase={2}bdb,cn=config
objectclass: olcconfig
objectclass: olcMemberOf
objectclass: olcoverlayconfig
objectclass: top
olcoverlay: memberof

EOF
}
#执行函数
add_memberof
