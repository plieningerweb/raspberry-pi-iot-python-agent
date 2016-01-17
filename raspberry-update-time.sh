sudo service ntp stop
#update time regardless of offset now
sudo ntpd -gq
sudo service ntp start
