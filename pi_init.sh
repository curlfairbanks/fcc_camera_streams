#!/bin/bash

git clone http://github.com/curlfairbanks/fcc_camera_streams.git /home/pi/curl_cam
chown -R pi:pi /home/pi/curl_cam

sed -i '\/home\/pi\/pi_init.sh/d' /etc/rc.local

/home/pi/curl_cam/pi_setup.sh

/sbin/reboot
