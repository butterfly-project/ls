#!/bin/bash

sudo apt-get install -y curl
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo npm i -g bower
sudo npm i -g "gulpjs/gulp-cli"
