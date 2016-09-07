#!/bin/bash

for ct in `pct list | grep running | cut -d' ' -f1`; do echo "echo $ct; pct exec $ct cat /etc/debian_version"; done | bash
