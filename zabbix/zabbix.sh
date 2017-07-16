#!/bin/bash

DBPASSWORD=`pwgen 10 1`

cd /tmp

wget http://repo.zabbix.com/zabbix/3.2/debian/pool/main/z/zabbix-release/zabbix-release_3.2-1+jessie_all.deb
sudo dpkg -i zabbix-release_3.2-1+jessie_all.deb
sudo apt-get update
sudo apt-get install -y zabbix-server-pgsql zabbix-frontend-php php5-pgsql

sudo -upostgres createdb zabbix
sudo -upostgres psql -c "CREATE USER zabbix WITH PASSWORD '$DBPASSWORD';"
sudo -upostgres psql -c "ALTER USER zabbix WITH SUPERUSER;"
zcat /usr/share/doc/zabbix-server-pgsql/create.sql.gz | sudo -upostgres psql zabbix

sudo cp /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf.bak
sudo sed -i "s/# DBPassword=/DBPassword=$DBPASSWORD/g" /etc/zabbix/zabbix_server.conf

sudo service zabbix-server start
sudo update-rc.d zabbix-server enable

sudo cp /etc/zabbix/apache.conf /etc/zabbix/apache.conf.bak
sudo sed -i "s/# php_value date.timezone Europe\/Riga/php_value date.timezone Europe\/Moscow/g" /etc/zabbix/apache.conf
sudo service apache2 restart
sudo rm -Rf /var/www/*

sudo cat > /etc/zabbix/web/zabbix.conf.php <<EOL
<?php
global $DB;

$DB['TYPE']            = 'POSTGRESQL';
$DB['SERVER']          = 'localhost';
$DB['PORT']            = '0';
$DB['DATABASE']        = 'zabbix';
$DB['USER']            = 'zabbix';
$DB['PASSWORD']        = '${DBPASSWORD}';
$DB['SCHEMA']          = '';

$ZBX_SERVER            = 'localhost';
$ZBX_SERVER_PORT       = '10051';
$ZBX_SERVER_NAME       = '';

$IMAGE_FORMAT_DEFAULT  = IMAGE_FORMAT_PNG;
EOL

sudo apt-get install -y zabbix-agent
sudo service zabbix-agent start
