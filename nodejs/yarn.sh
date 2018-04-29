#!/bin/bash

docker run --rm -it -v $(pwd):/usr/local/app -v volume-yarn-cache:/usr/local/share/.cache/yarn agregad/node yarn $@
