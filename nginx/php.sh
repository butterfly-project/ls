#!/bin/bash

sudo apt-get purge 'php5*' -y
sudo apt-get purge 'php7.0-*' -y

sudo apt update
sudo apt install apt-transport-https lsb-release ca-certificates -y

sudo wget -O /etc/apt/trusted.gpg.d/php.gpg \
https://packages.sury.org/php/apt.gpg

echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" |
sudo tee /etc/apt/sources.list.d/php.list

sudo apt update
sudo apt install -y php7.1 php7.1-cli php7.1-common php7.1-mysql php7.1-pgsql php7.1-gd php7.1-fpm php7.1-cgi php-pear php7.1-mcrypt php7.1-curl php7.1-json php7.1-readline php7.1-redis php7.1-mbstring php7.1-zip php7.1-intl

cd /etc/nginx/sites-enabled
sudo sed -i "s/php7.0-fpm/php7.1-fpm/g" *

cp /etc/php/7.1/fpm/php.ini /etc/php/7.1/fpm/php.ini.bak
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.1/fpm/php.ini

cp /etc/php/7.1/fpm/pool.d/www.conf /etc/php/7.1/fpm/pool.d/www.conf.bak
sed -i "s/;security.limit_extensions/security.limit_extensions/g" /etc/php/7.1/fpm/pool.d/www.conf

service nginx restart
service php7.1-fpm restart

cd /tmp
rm -Rf /usr/local/lib/composer.phar /usr/local/bin/composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
cp composer.phar /usr/local/lib
ln -s /usr/local/lib/composer.phar /usr/local/bin/composer
