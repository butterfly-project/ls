#!/bin/bash

sudo sh -c "echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' > /etc/apt/sources.list.d/java-8-debian.list"
sudo sh -c "echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list.d/java-8-debian.list"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
sudo apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install oracle-java8-installer -y
sudo apt-get install oracle-java8-set-default -y
