#!/bin/bash


read -r -d '' CONF << EOF
# define static profile
profile static_eth0
static ip_address=192.168.1.5/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1

# fallback to static profile on eth0
interface eth0
fallback static_eth0
EOF

set -e
set -u
set -x


#check if config already added
if ! grep -q  "profile static_eth0" "/etc/dhcpcd.conf"
then
  echo "add static default ip address 192.168.1.5"
  echo "$CONF" >> /etc/dhcpcd.conf
else
  echo "static default ip already set"
fi
