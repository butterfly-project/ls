#!/bin/bash

USER=$1


echo 'Upgrade system'
apt update && apt upgrade -y


echo 'Configure locale'
localedef ru_RU.UTF-8 -i ru_RU -fUTF-8
localedef en_US.UTF-8 -i en_US -fUTF-8

timedatectl set-timezone Europe/Moscow
dpkg-reconfigure -f noninteractive tzdata


echo 'Install minimal programs'
apt install -y ssh sudo vim-nox htop iftop git build-essential software-properties-common


echo 'Create user'
useradd -m -d /home/$USER -s /bin/bash $USER
adduser $USER sudo
echo 'agregad ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/agregad

cd /tmp
wget https://raw.githubusercontent.com/butterfly-project/ls/master/config/.bashrc
mv .bashrc /home/$USER/

mkdir /home/$USER/.ssh/
wget https://raw.githubusercontent.com/butterfly-project/ls/master/config/id_rsa.pub
mv id_rsa.pub /home/$USER/.ssh/
chown $USER:$USER /home/$USER/.ssh/id_rsa.pub
chmod 600 /home/$USER/.ssh/id_rsa.pub


echo 'Configure ssh'
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed "s/PermitRootLogin yes/PermitRootLogin no/g;s/LoginGraceTime 120/LoginGraceTime 45/g;" /etc/ssh/sshd_config.bak > /etc/ssh/sshd_config
echo 'ClientAliveInterval 300' >> /etc/ssh/sshd_config
echo "AllowUsers $USER" >> /etc/ssh/sshd_config
service ssh restart
