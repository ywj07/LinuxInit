#!/bin/bash
function pw_audit(){
cat << EOF | ldapadd -Y EXTERNAL -H ldapi:///
dn: cn=module{0},cn=config
changetype: modify
add: olcModuleLoad
olcModuleLoad: {1}auditlog

dn: olcOverlay=auditlog,olcDatabase={2}bdb,cn=config
changetype: add
objectClass: olcOverlayConfig
objectClass: olcAuditLogConfig
olcOverlay: auditlog
olcAuditLogFile: /var/log/slapd/auditlog.log
EOF
}

pw_audit
