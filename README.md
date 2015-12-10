# raspberry-pi-iot-python-agent
Raspbery Pi IOT Python Agent Installation


#on laptop

check gsm stick and change config to use correct apn

for congstar, e.g.
```
APN:      internet.t-mobile
1. DNS:     193.254.160.1
2. DNS:     -
Benutzername:    t-mobile
Passwort:     tm
IP-Adresse:    dynamisch
IP-Header Komprimierung:  nein
Proxy verwenden:   nein
```

#on rpi

```
#insert usb umts stick
#thx to https://www.raspberrypi.org/forums/viewtopic.php?t=38392&p=317787
sudo su
apt-get update
apt-get upgrade
apt-get install sg3-utils
echo 'SUBSYSTEMS=="usb", ATTRS{modalias}=="usb:v12D1p1F01*", SYMLINK+="hwcdrom", RUN+="/usr/bin/sg_raw /dev/hwcdrom 11 06 20 00 00 00 00 00 01 00"' > /etc/udev/rules.d/10-HuaweiFlashCard.rules
reboot
```

```
DEVICECREDENTIALSPW="YourCumulocityDeviceCredentialsApiPw"

sudo apt-get install vnstat 
#todo: chagne itnerface name
sudo vnstat -u -i eth1
sudo service vnstat start 
#fix: vnstat was not updating
sudo chown -R vnstat:vnstat /var/lib/vnstat

```


```
sudo apt-get install autossh
```

```
sudo apt-get install git
sudo apt-get install python3
```

```
cd ~
git clone https://github.com/plieningerweb/cumulocity-python-device-client.git
```


```
cd cumulocity-python-device-client/
#TODO: not yet working, chage it!
echo "deviceCredentialsPassword = $DEVICECREDENTIALSPW" >> cumulocity.cfg
```

```
#supervise is in pacakge daemontool
sudo apt-get -y install daemontools daemontools-run authbind

#add supervise folder to supervise
sudo update-service --add /home/pi/cumulocity-python-device-client/supervise/ cumulocityclient

#start supervise
sudo svc -u /home/pi/cumulocity-python-device-client/supervise/
```



