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
./raspberry-app.sh

echo "installation of raspberry finished"
