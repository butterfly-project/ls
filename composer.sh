#!/bin/bash

docker run --rm -it -v $(pwd):/app -v volume-composer-cache:/root/composer/ prooph/composer:7.1 $@
