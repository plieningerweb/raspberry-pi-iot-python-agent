#!/bin/bash

echo "install support for huawei e303 on raspberry"


read -r -d '' CONF << EOF
#huawei e303
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1f01", RUN+="/usr/sbin/usb_modeswitch -v 0x12d1 -p 0x1f01 -M '55534243123456780000000000000a11062000000000000100000000000000'"
EOF

set -e
set -u
set -x

echo "$CONF" > /etc/udev/rules.d/75-usb-modeswitch.rules

echo "install usb-modeswitch"

apt-get install -y usb-modeswitch

echo "installation finished"
