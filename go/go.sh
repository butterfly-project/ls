#!/bin/bash

docker run --rm -it -v $(pwd):/go golang go $@
