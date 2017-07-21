#!/bin/bash

filename=$1
domain=$2

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout $filename.key -out $filename.crt -subj "/C=RU/ST=Moscow/L=Moscow/O=Example Moscow Company/CN=$domain"
