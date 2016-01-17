#!/bin/bash
## install application

APP_ROOT="/home/pi/app-pv"

set -e
set -u
set -x

echo "install app"

apt-get -y install git python-pip
pip install --upgrade pip

git clone https://github.com/plieningerweb/cumulocity-python-device-client.git "$APP_ROOT"

cd "$APP_ROOT"

#use new config file
cp /install/app.cfg "$APP_ROOT"

#use new app file
cp /install/app.py "$APP_ROOT"

#add dependencies
pip install kacors485

#enable supervise
cd "$APP_ROOT"
./setup-supervise.sh

echo "app installation finished"
