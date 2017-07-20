#!/bin/bash

sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main"
sudo apt-get update

echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
