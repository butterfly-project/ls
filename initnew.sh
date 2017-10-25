#!/bin/bash

SSH_USERS=$1

echo 'Upgrade system'
apt-get update && apt-get upgrade -y

echo 'Configure locale'
localedef ru_RU.UTF-8 -i ru_RU -fUTF-8
localedef en_US.UTF-8 -i en_US -fUTF-8

echo 'Configure timezone'
echo 'Europe/Moscow' > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

echo 'Install minimal programs'
apt-get install -y ssh sudo vim-nox htop iftop git build-essential software-properties-common python-software-properties

echo 'Configure ssh'
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed "s/PermitRootLogin yes/PermitRootLogin no/g;s/LoginGraceTime 120/LoginGraceTime 45/g;" /etc/ssh/sshd_config.bak > /etc/ssh/sshd_config
echo 'ClientAliveInterval 300' >> /etc/ssh/sshd_config
echo "AllowUsers $SSH_USERS" >> /etc/ssh/sshd_config
service ssh restart

