#!/bin/bash
ldapserver="ldap://192.168.6.28"
ldapbasedn="dc=ldap,dc=richstonedt,dc=com"

#install openldap-clients
yum install -y openldap-clients nss-pam-ldapd

#enable ldapuser can auto mkdir homedir
echo "session required pam_mkhomedir.so skel=/etc/skel umask=0077" >> /etc/pam.d/system-auth

#configure linux use ldap authenticate
authconfig --savebackup=auth.bak
authconfig --enablemkhomedir --disableldaptls --enableldap --enableldapauth --ldapserver=$ldapserver --ldapbasedn=$ldapbasedn --update 

#enabled ssh can accept ldap to login
sed -i "s/sss/ldap/g" /etc/pam.d/system-auth
sed -i "s/sss/ldap/g" /etc/pam.d/system-auth-ac
sed -i "s/sss/ldap/g" /etc/pam.d/password-auth
sed -i "s/sss/ldap/g" /etc/pam.d/password-auth-ac

#client setup to accept server password policy
echo "bind_policy soft" >> /etc/pam_ldap.conf
echo "pam_password md5" >> /etc/pam_ldap.conf
echo "pam_lookup_policy yes" >> /etc/pam_ldap.conf
echo "pam_password clear_remove_old" >> /etc/pam_ldap.conf

#Options: client sudoers configure
echo -e "uri $ldapserver\nSudoers_base ou=sudoers,$ldapbasedn" >> /etc/sudo-ldap.conf
echo "Sudoers: files ldap" >>  /etc/nsswitch.conf

#Options: enable client host deny
echo "pam_check_host_attr yes" >> /etc/pam_ldap.conf
