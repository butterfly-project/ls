#!/bin/bash

sudo useradd -m -d /home/$1 -s /bin/bash $1
sudo passwd $1
sudo adduser $1 sudo
