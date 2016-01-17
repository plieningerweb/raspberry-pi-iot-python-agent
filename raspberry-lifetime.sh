#!/bin/bash
## extend lifetime of sd card by optimizing it
##
## this file will especially
## - disable swap
## - map /var/log and /tmp to ram instead of sdcard (volatile)
## - map /var/tmp to /tmp and therefore also to ram


read -r -d '' FSTABNEW << EOF
  proc            /proc           proc    defaults          0       0
  /dev/mmcblk0p1  /boot           vfat    defaults          0       2
  /dev/mmcblk0p2  /               ext4    defaults,noatime  0       1
  # a swapfile is not a swap partition, so no using swapon|off from here on, use  dphys-swapfile swap[on|off]  for that

  #write /var/tmp and /var/log to ram
  tmpfs 			/tmp 			tmpfs 	defaults,noatime,nosuid,mode=1777,size=150m 0 0
  tmpfs 			/var/log 		tmpfs 	defaults,noatime,nosuid,mode=0755,size=150m 0 0
EOF

set -e
set -u
set -x


#unix timestamp
TIMESTAMP=`date +"%s"`

#check if we run this on an rpi
#because on your host computer, this will delete stuff and break it (fstab)
#check if raspi-config is installe
if hash raspi-config 2>/dev/null; then
  echo "assume I am running on raspberry"
else
  echo "can not find raspi-config"
  echo "I think I am not running on a raspberry, stop now!"

  exit 1
fi

echo "disable swap service"
update-rc.d dphys-swapfile remove

#use hash, check http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if hash dphys-swapfile 2>/dev/null; then
  echo "disable swap"
  dphys-swapfile swapoff
  dphys-swapfile uninstall
  apt-get -y purge dphys-swapfile
fi

#noatime is already set in /etc/fstab
echo "link /tmp and /var/log to ram"

echo "backup old fstab file"
cp /etc/fstab "/etc/fstab.backup-$TIMESTAMP"

echo "install new fstab file"
echo "$FSTABNEW" > /etc/fstab

#link /var/tmp to /tmp, so we need only one mount point
rm -rf /var/tmp
ln -s /tmp /var/tmp

echo "raspberry lifetime installation finished"
