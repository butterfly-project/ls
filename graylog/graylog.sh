#!/bin/bash

sudo echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list
sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y install apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen












# install java 8
sudo sh -c "echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' > /etc/apt/sources.list.d/java-8-debian.list"
sudo sh -c "echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list.d/java-8-debian.list"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
sudo apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer oracle-java8-set-default

# install mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.2 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo service mongod start

# install elasticsearch
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
sudo apt-get install -y apt-transport-https curl
sudo apt-get update 
sudo apt-get install -y elasticsearch
sudo update-rc.d elasticsearch defaults 95 10
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.bak
sed "s/# cluster.name: my-application/cluster.name: graylog/g" /etc/elasticsearch/elasticsearch.yml.bak > /etc/elasticsearch/elasticsearch.yml
sudo sh -c "echo 'network.bind_host: localhost ' >> /etc/elasticsearch/elasticsearch.yml"
sudo service elasticsearch restart
curl -XGET 'http://localhost:9200/_cluster/health?pretty=true'

# install graylog
wget https://packages.graylog2.org/repo/packages/graylog-2.2-repository_latest.deb
sudo dpkg -i graylog-2.2-repository_latest.deb
sudo apt-get update
sudo apt-get install -y graylog-server
sudo rm -f /etc/init/graylog-server.override

sudo apt-get install -y pwgen
SECRET=$(pwgen -s 96 1)
sudo -E sed -i -e 's/password_secret =.*/password_secret = '$SECRET'/' /etc/graylog/server/server.conf
PASSWORD=$(echo -n 123456789 | shasum -a 256 | awk '{print $1}')
sudo -E sed -i -e 's/root_password_sha2 =.*/root_password_sha2 = '$PASSWORD'/' /etc/graylog/server/server.conf
IP=$(hostname -I)
sudo -E sed -i -e 's/rest_listen_uri = http:\/\/127.0.0.1:12900\//rest_listen_uri = http:\/\/'$IP':12900\//' /etc/graylog/server/server.conf
sudo -E sed -i -e 's/#web_listen_uri = http:\/\/127.0.0.1:9000\//web_listen_uri = http:\/\/'$IP':9000\//' /etc/graylog/server/server.conf
sudo -E sed -i -e 's/elasticsearch_index_prefix = .*/elasticsearch_index_prefix = graylog /' /etc/graylog/server/server.conf

sudo systemctl daemon-reload
sudo systemctl enable graylog-server.service
sudo systemctl start graylog-server.service
sudo systemctl start graylog-server
sudo systemctl status graylog-server.service
sudo systemctl status graylog-server


