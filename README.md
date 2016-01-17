# raspberry-pi-iot-python-agent
Raspbery Pi IOT Python Agent Installation


## Troubeshooting

### Wrong default gateway

If default gateway is ethernet 0 (cable) and not eth1 (umts stick), then we get no internet connection.

run on rpi to fix:
```
sudo route del default
sudo route add default 192.168.8.1
```

## Sent meausrements but not displayed

Maybe the timestamp of the sent measurements is wrong or very old. Check to update time using `raspberry-update-time.sh`.

# on laptop

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

Copy Rasbian Image on SD Card

```
#copy image to raspberry sd card
#sudo dd bs=4M if=2015-11-21-raspbian-jessie-lite.img  of=/dev/sdb
```

Default network configuration for eth0
```
/etc/dhcpcd.conf
# define static profile
profile static_eth0
static ip_address=192.168.1.23/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1

# fallback to static profile on eth0
interface eth0
fallback static_eth0
```

Configure umts stick on raspberry
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

Begin installing cumulocity app
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
sudo apt-get install python
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
sudo apt-get install -yy python-pip
sudo pip install --upgrade pip

```

```
#supervise is in pacakge daemontool
sudo apt-get -y install daemontools daemontools-run


#add supervise folder to supervise
sudo update-service --add /home/pi/cumulocity-python-device-client/supervise/ cumulocityclient

#start supervise
sudo svc -u /home/pi/cumulocity-python-device-client/supervise/

#checkout log files
tail -f /tmp/cumulocity-log/current
```
