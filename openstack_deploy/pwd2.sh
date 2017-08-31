#!/bin/sh
mv /root/.ssh/authorized_keys /root/.ssh/authorized_keys.old
cp  /home/centos/.ssh/authorized_keys /root/.ssh/
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
service  sshd restart 
passwd root<<EOF
pass
pass
EOF

useradd  centos
passwd centos<<EOF
pass123
pass123
EOF

