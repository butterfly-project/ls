#!/bin/bash

USER=$1

echo "Create user $USER"
sudo useradd -m -d /home/$USER -s /bin/bash $USER
sudo passwd $USER
sudo adduser $USER sudo
