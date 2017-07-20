#!/bin/bash

hostname=$1
cores=$2  
ram=$3       # Mb
swap=$4      # Mb
disk=$5      # Gb


vmid=`pct list | cut -d' ' -f1 | grep -v VMID | sort | tail -1`

if [[ -z $vmid ]]
then vmid=99
fi

((vmid++))

storage="local"
template="/var/lib/vz/template/cache/debian-8.0-x86_64.tar.gz"

# network
if="eth0"
bridge="vmbr0"
ip="dhcp"

pct create $vmid $template \
  -hostname $hostname \
  -cores $cores \
  -memory $ram \
  -swap $swap \
  -storage $storage \
  -rootfs $storage:$disk \
  -net0 name=$if,ip=$ip,bridge=$bridge

pct set $vmid -onboot 1
pct start $vmid
