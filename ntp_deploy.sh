#!/bin/bash

if [ "$USER" != root ]; then
        echo "The user $USER  doesn't have root access"
        exit 1
fi

#NTP installation
apt-get install -y ntp >/dev/null

cp /etc/ntp.conf /etc/ntp.conf_default

#cat /etc/ntp.conf | sed -e 's/.*pool.ntp.org.*/server\ ua.pool.ntp.org/g' 1> /etc/ntp.conf
sed -i '/pool.ntp.org/d; /more information/a pool ua.pool.ntp.org' /etc/ntp.conf

systemctl restart ntp.service

cp /etc/ntp.conf /etc/ntp.conf_standard

ntpdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

touch /etc/cron.d/ntp

echo "SHELL=/bin/bash" > /etc/cron.d/ntp
echo "MAILTO=root" >> /etc/cron.d/ntp
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >> /etc/cron.d/ntp
echo "*/1     *    *    *    *    root    "$ntpdir"/ntp_verify.sh" >> /etc/cron.d/ntp


