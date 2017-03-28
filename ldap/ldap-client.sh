#!/bin/bash

LDAP_HOST=$1
LDAP_BASE="dc=nodomain"
LDAP_BINDDN="cn=nssproxy,ou=users,dc=nodomain"
LDAP_BINDPW=$2

DEBIAN_FRONTEND=noninteractive apt-get install -y ldap-utils libnss-ldapd libpam-ldapd python-dev python-pip python-ldap libsasl2-dev libldap2-dev libssl-dev

cat > /etc/ldap/ldap.conf <<EOL
BASE   ${LDAP_BASE}
URI    ldap://${LDAP_HOST}
EOL

cat > /etc/nslcd.conf <<EOL
uid nslcd
gid nslcd
uri ldap://${LDAP_HOST}/
base ${LDAP_BASE}
binddn ${LDAP_BINDDN}
bindpw ${LDAP_BINDPW}
base group ou=groups,dc=nodomain
base passwd ou=users,dc=nodomain
base shadow ou=users,dc=nodomain
nss_initgroups_ignoreusers bin,daemon,games,lp,mail,nobody,nslcd,root,sshd,sync,uucp
nss_initgroups_ignoreusers sys,man,news,proxy,www-data,backup,list,irc,gnats
pam_authz_search (&(objectClass=posixAccount)(uid=\$username)(|(host=\$hostname)(host=\$fqdn)(host=\\\\*)))
EOL

cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
sed 's/passwd:         compat/passwd:         compat ldap/g;s/group:          compat/group:          compat ldap/g;s/netgroup:       nis/netgroup:       nis ldap/g' /etc/nsswitch.conf.bak > /etc/nsswitch.conf
echo 'sudoers:        files ldap' >> /etc/nsswitch.conf

echo "session required pam_mkhomedir.so umask=0022 skel=/etc/skel/ silent" >> /etc/pam.d/common-session

service nscd restart
service nslcd restart

pip install ssh-ldap-pubkey
cp /usr/local/bin/ssh-ldap-pubkey-wrapper /usr/bin/

cat > /etc/ldap.conf <<EOL
BASE    ${LDAP_BASE}
URI     ldap://${LDAP_HOST}
binddn  ${LDAP_BINDDN}
bindpw  ${LDAP_BINDPW}
EOL

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

sed 's/\#PasswordAuthentication yes/PasswordAuthentication no/g;s/\#AuthorizedKeysFile\t%h\/.ssh\/authorized_keys/AuthorizedKeysFile \/dev\/null/g' /etc/ssh/sshd_config.bak > /etc/ssh/sshd_config

cat >> /etc/ssh/sshd_config <<EOL
AuthorizedKeysCommand /usr/bin/ssh-ldap-pubkey-wrapper
AuthorizedKeysCommandUser root
EOL

service ssh restart

DEBIAN_FRONTEND=noninteractive apt-get install -y sudo-ldap

rm /etc/sudo-ldap.conf
cat > /etc/sudo-ldap.conf <<EOL
BASE    ${LDAP_BASE}
URI     ldap://${LDAP_HOST}
binddn  ${LDAP_BINDDN}
bindpw  ${LDAP_BINDPW}

SUDOERS_BASE    ou=sudo,ou=services,dc=nodomain
#SUDOERS_DEBUG 2
EOL

chown root:root    /etc/ldap/ldap.conf /etc/ldap.conf /etc/sudo-ldap.conf
chown nslcd:nslcd  /etc/nslcd.conf

chmod 600 /etc/ldap/ldap.conf /etc/ldap.conf /etc/sudo-ldap.conf /etc/nslcd.conf

