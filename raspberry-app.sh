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
cp /install/app/app.cfg "$APP_ROOT"

#use new app file
cp /install/app/app-pv.py "$APP_ROOT"

#use new run file for app-pv
cp /install/app/supervise/run "$APP_ROOT/supervise"


#add dependencies
pip install kacors485

#enable supervise
cd "$APP_ROOT"
./setup-supervise.sh

echo "app installation finished"
