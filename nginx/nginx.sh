#!/bin/bash

apt-get remove -y apache2
apt-get install -y nginx nginx-extras apache2-utils
wget -P /usr/local/bin/ https://raw.githubusercontent.com/butterfly-project/ls/master/nginx/ngx && chmod +x /usr/local/bin/ngx

