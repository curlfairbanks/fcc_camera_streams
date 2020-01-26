#!/bin/bash

git clone http://github.com/curlfairbanks/fcc_camera_streams.git /home/pi/curl_cam
chown -R pi:pi /home/pi/curl_cam

/home/pi/curl_cam/pi_setup.sh

/sbin/reboot
