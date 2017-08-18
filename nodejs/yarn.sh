#!/bin/bash

docker run --rm -it -v $(pwd):/usr/src/app -v volume-yarn-cache:/usr/local/share/.cache/yarn agregad/node yarn $@
