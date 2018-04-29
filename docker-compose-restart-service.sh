#!/bin/bash

notify-send Git "docker-compose restart $1\n"

docker-compose restart $1
