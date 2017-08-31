#!/bin/bash
basedn="dc=ldap,dc=richstonedt,dc=com"
#ppolicy_dit="cn=highlevel,ou=pwpolicies,dc=my-domain,dc=com"

ldif_dir=/tmp/openldap/ldif

if [ -d "$ldif_dir" ]; then
        rm -rf $ldif_dir/*
else
        mkdir -p $ldif_dir
fi

function load_user_ldif(){
cat >> $ldif_dir/staff.ldif << EOF
dn: uid=$1,ou=fs-staff,ou=userAccount,$basedn
uid: $1
cn: $1
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: top
loginShell: /bin/bash
uidNumber: $2
gidNumber: $3
sn: $1
mail: $1@richstonedt.com
homeDirectory: /home/$1
userPassword: $4
displayName: $6
pwdReset: TRUE

EOF
}

function modify_user_appgroup(){
cat >> $ldif_dir/$1.ldif << EOF
dn: cn=$1,ou=Atlassian,ou=appGroup,$basedn
changetype: modify
add: member
EOF
}

function modify_user_linuxgroup(){
cat >> $ldif_dir/linuxgroup.ldif << EOF
dn: cn=$1,ou=linuxGroup,$basedn
changetype: modify
add: memberuid
EOF
}
modify_user_linuxgroup normalusers
modify_user_appgroup confluence-users
modify_user_appgroup jira-software-users

#group=(rd pd hr finance)
group=(rd pd)
for dept in ${group[@]}
do
staffname=($(awk '{print $1}' /tmp/${dept}_usr_list))
staffnum=($(awk '{print $2}' /tmp/${dept}_usr_list))
groupid=($(awk '{print $3}' /tmp/${dept}_usr_list))
userpw=($(awk '{print $4}' /tmp/${dept}_usr_list))
deptid=($(awk '{print $5}' /tmp/${dept}_usr_list))
dispalyname=($(awk '{print $6}' /tmp/${dept}_usr_list))
usercount=$(echo |awk 'END{print NR}' /tmp/${dept}_usr_list)

if [ -f $ldif_dir/richstonedt_${dept}_department.ldif ] 
then
        rm -rf $ldif_dir/richstonedt_${dept}_department.ldif
else
        touch $ldif_dir/richstonedt_${dept}_department.ldif
fi

if [ -f $ldif_dir/${dept}.txt ]
then
        rm -rf $ldif_dir/${dept}.txt
else
        touch $ldif_dir/${dept}.txt
fi


if [ ${dept} == "rd" ] ; then
modify_user_appgroup richstonedt_rd_department
elif [ ${dept} == "pd" ] ; then
modify_user_appgroup richstonedt_pd_department
elif [ ${dept} == "hr" ] ; then
modify_user_appgroup richstonedt_hr_department
else
modify_user_appgroup richstonedt_finance_department
fi

#modify_user_linuxgroup normalusers

for ((i=0;i<usercount;i++)) ; do
load_user_ldif ${staffname[i]} ${staffnum[i]} ${groupid[i]} ${userpw[i]} ${deptid[i]} ${dispalyname[i]}
echo "memberuid: ${staffname[i]}" >> $ldif_dir/linuxgroup.txt
echo "member: uid=${staffname[i]},ou=fs-staff,ou=userAccount,$basedn" >> $ldif_dir/appgroup.txt

if [ ${deptid[i]} == 10 ]; then
echo "member: uid=${staffname[i]},ou=fs-staff,ou=userAccount,$basedn" >> $ldif_dir/rd.txt
elif [ ${deptid[i]} == 20 ]; then
echo "member: uid=${staffname[i]},ou=fs-staff,ou=userAccount,$basedn" >> $ldif_dir/pd.txt
elif [ ${deptid[i]} == 30 ]; then
echo "member: uid=${staffname[i]},ou=fs-staff,ou=userAccount,$basedn" >> $ldif_dir/hr.txt
else
echo "member: uid=${staffname[i]},ou=fs-staff,ou=userAccount,$basedn" >> $ldif_dir/finance.txt
fi
done

cat $ldif_dir/${dept}.txt >> $ldif_dir/richstonedt_${dept}_department.ldif

done

cat $ldif_dir/linuxgroup.txt >> $ldif_dir/linuxgroup.ldif
cat $ldif_dir/appgroup.txt >> $ldif_dir/confluence-users.ldif
cat $ldif_dir/appgroup.txt >> $ldif_dir/jira-software-users.ldif
