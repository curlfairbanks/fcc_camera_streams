#/usr/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "Installing camera control script to /usr/local/bin"
cp python/camera_control /usr/local/bin

echo "Installing systemd services into /etc/systemd/system"
cp systemd/SHEET@.service /etc/systemd/system
cp systemd/camera_control.service /etc/systemd/system

echo "reloading system daeamon"
systemctl daemon-reload
