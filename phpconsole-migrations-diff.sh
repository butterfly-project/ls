#!/bin/bash

notify-send Git "migrations:diff\n"

phpcroncontainer=$(docker-compose ps | grep php-cron | cut -d' ' -f1)

docker exec -i $phpcroncontainer app/console migrations:diff
sudo chown agregad:agregad site_php/src/Migrations/*
