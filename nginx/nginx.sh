#!/bin/bash

apt-get install -y nginx nginx-extras apache2-utils
wget -P /usr/local/bin/ https://raw.githubusercontent.com/butterfly-project/ls/master/nginx/ngx && chmod +x /usr/local/bin/ngx

echo -e "deb http://packages.dotdeb.org jessie all\ndeb-src http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list
wget https://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg
apt-get update
apt-get install -y php7.0-cli php7.0-common php7.0-mysql php7.0-pgsql php7.0-gd php7.0-fpm php7.0-cgi php7.0-fpm php-pear php7.0-mcrypt php7.0-curl php7.0-json php7.0-readline php7.0-redis php7.0-mbstring php7.0-zip php7.0-intl

cp /etc/php/7.0/fpm/php.ini /etc/php/7.0/fpm/php.ini.bak
sed "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini.bak > /etc/php/7.0/fpm/php.ini

cp /etc/php/7.0/fpm/pool.d/www.conf /etc/php/7.0/fpm/pool.d/www.conf.bak
sed "s/;security.limit_extensions/security.limit_extensions/g" /etc/php/7.0/fpm/pool.d/www.conf.bak > /etc/php/7.0/fpm/pool.d/www.conf

service nginx restart
service php7.0-fpm restart

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
cp composer.phar /usr/local/lib
ln -s /usr/local/lib/composer.phar /usr/local/bin/composer
