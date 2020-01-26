#!/bin/bash

if [ -d "/home/pi/curl_cam.old" ]
then
	rm -rf /home/pi/curl_cam.old
	mv /home/pi/curl_cam /home/pi/curl_cam.old
fi

if [ -d "/home/pi/curl_cam" ]
then
	rm -rf /home/pi/curl_cam
fi

git clone https://github.com/curlfairbanks/fcc_camera_streams.git /home/pi/curl_cam
chown -R pi:pi /home/pi/curl_cam

sed -i '\/home\/pi\/pi_init.sh/d' /etc/rc.local

/home/pi/curl_cam/pi_setup.sh

/sbin/reboot
