#!/bin/bash

IP=$1

sudo apt-get install -y zabbix-agent

sudo cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bak
sudo sed -i "s/Server=127.0.0.1/Server=${IP}/g" /etc/zabbix/zabbix_agentd.conf

sudo service zabbix-agent restart
