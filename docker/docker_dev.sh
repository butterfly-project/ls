#!/bin/bash

sudo apt-get remove -y docker docker-engine docker.io
sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

sudo apt-get update
sudo apt install -y docker-ce

sudo apt install -y python-pip
sudo pip install docker-compose

sudo groupadd docker
sudo usermod -aG docker $USER

sudo docker run hello-world

echo 'Restart console for apply docker permissions'
