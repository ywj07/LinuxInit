#!/bin/bash

yum -y install openssh-ldap
cp /usr/share/doc/sudo-1.8.6p3/schema.OpenLDAP /etc/openldap/schema/sudo.schema
cp /usr/share/doc/openssh-ldap-5.3p1/openssh-lpk-openldap.schema  /etc/openldap/schema/
slapconf_file=/etc/openldap/slapd.conf

sed -i '/Allow LDAP/i\include         /etc/openldap/schema/sudo.schema\ninclude         /etc/openldap/schema/openssh-lpk-openldap.schema\n' $slapconf_file

/bin/bash ./openldap_ldapdb_reload.sh
