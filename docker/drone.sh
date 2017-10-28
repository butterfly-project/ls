#!/bin/bash

docker run --rm -it -e DRONE_SERVER=$DRONE_SERVER -e DRONE_TOKEN=$DRONE_TOKEN agregad/dronecli $@
