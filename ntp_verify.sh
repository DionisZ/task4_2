#!/bin/bash

#NTP service check

if [ $(ps ax | grep ntpd | grep -v grep | wc -l) -eq 0 ]; then
	echo "NOTICE: ntp is not running"
	sudo service ntp start
fi


#ntp.comf differences check
if [ $(diff -u0B /etc/ntp.conf_standard /etc/ntp.conf | wc -l) -ne 0 ]; then
	echo "NOTICE: /etc/ntp.conf was changed"
	diff -u0B /etc/ntp.conf_standard /etc/ntp.conf
	cp /etc/ntp.conf_standard /etc/ntp.conf
	service ntp restart
fi

