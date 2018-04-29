#!/bin/bash

IN=$@

while IFS=' ' read -ra ADDR; do
  for i in "${ADDR[@]}"; do
    ips=$(docker inspect -f '{{ .Name }} {{ range .NetworkSettings.Networks }}{{ .IPAddress }} {{ end }}' $i)
    echo "$i $ips"
  done
done <<< "$IN"
