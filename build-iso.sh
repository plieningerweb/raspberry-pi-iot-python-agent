#!/bin/bash

#error -> exit script
set -e
# not initalized var -> error
set -u

#show every command
set -x


IMAGE_URL="https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2015-11-24/2015-11-21-raspbian-jessie-lite.zip"
IMAGE_DOWNLOAD_NAME="raspbian-image-lite.zip"

IMAGE_NAME=""

MOUNT_POINT_ROOT="/media"

#resource dir will be mapped to /install dir on emulated device
RESOURCE_DIR="~/"

is_root()
{
  if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
  fi
}

getIMAGE_NAME()
{
  IMAGE_NAME=`ls *.img | head -n 1`
}

download()
{
  echo "Downlaod image"

  #make progress pretty
  wget -c --progress=dot -O "$IMAGE_DOWNLOAD_NAME" "$IMAGE_URL" 2>&1 | grep --line-buffered "%" | \
    sed -u -e "s|\.||g" -e "s|,||g" | awk '{printf("\b\b\b\b%4s", $2)}'

  unzip "$IMAGE_DOWNLOAD_NAME"
}

domount()
{
  echo "mount image"

  #setup loop device
  LOOP_DEV=`losetup -f --show $IMAGE_NAME`

  mkdir -p "$MOUNT_POINT_ROOT"

	mount -o offset=$(( 512 * 122880 )),loop "$LOOP_DEV" "$MOUNT_POINT_ROOT"

  echo "image mounted on $MOUNT_POINT_ROOT"
}

dounmount()
{
  echo "unmount image"

  umount "$MOUNT_POINT_ROOT"

  #delete loop device
  losetup -d "$LOOP_DEV"
}

check_dep()
{
  if [ $(dpkg-query -W -f='${Status}' qemu-user 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo "please install qemu-user, e.g."
    echo "apt-get install qemu-user"
    exit 1
  fi

  if [ $(dpkg-query -W -f='${Status}' proot 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo "please install proot, e.g."
    echo "apt-get install proot"
    exit 1
  fi
}

qemu_run()
{
  echo "start bash on image"
  echo "/install folder will contain resource directory"

  proot -q qemu-arm -r "$MOUNT_POINT_ROOT" -b "$RESOURCE_DIR:/install"
}



#check dependencies
check_dep

#check if we got image
getIMAGE_NAME

if [ ! -f "$IMAGE_NAME" ]; then
	download

  #now check again
  getIMAGE_NAME
  if [ ! -f "$IMAGE_NAME" ]; then
  	echo "could not download or find image"
    exit 1
  fi

fi

#check root
is_root

#mount
domount

#start emulator
qemu_run

#unmount
dounmount

echo "changes were stored in image"
echo "now you can e.g. write the image to a sd card"
echo "sudo dd bs=4M if=image.img  of=/dev/sdz"
