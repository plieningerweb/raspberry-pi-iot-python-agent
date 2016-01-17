#!/bin/bash

#thise file installs all the stuff on the raspberry

set -e
set -u
set -x

#get current directory as absolute path
MYDIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MYDIR" ]]; then MYDIR="$PWD"; fi
cd "$MYDIR"
MYDIR=`pwd`

#update and upgrae raspberry
apt-get update > /dev/null
apt-get upgrade -yy

#increase sd card lifetime
./raspberry-lifetime.sh

#set static ip address
./raspberry-staticip.sh

#install huawei e303 support
./raspberry-huawei-e303.sh


#install application
APP_ROOT="/home/pi/app-pv"

apt-get -y install git python-pip
pip install --upgrade pip

cd "$APP_ROOT"
git checkout https://github.com/plieningerweb/cumulocity-python-device-client.git "$APP_ROOT"

#use new config file
cp /install/app.cfg "$APP_ROOT"

#use new app file
cp /install/app.py "$APP_ROOT"

#add dependencies
pip install kacors485

#enable supervise
cd $"APP_ROOT"
./setup-supervise.sh

echo "app installation finished"
