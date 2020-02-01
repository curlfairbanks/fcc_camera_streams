#!/bin/bash
# Takes single argument
trap 'kill $RIGHT_PID; kill $LEFT_PID; exit' INT

CREDDIR="/etc/curl_cam/creds"

if [ -z $1 ]; then
  echo "Requires camera name"
  exit 1
fi

wait_right(){
  while [ -e /proc/$RIGHT_PID ]
  do
    sleep .6
  done
  echo "right omxplayer has quit"
  exit 1
}

wait_left(){
  while [ -e /proc/$LEFT_PID ]
  do
    sleep .6
  done
  echo "left omxplayer has quit"
  exit 1
}

if [ -f $CREDDIR/credentials.config ]; then source $CREDDIR/credentials.config; fi
if [ -f /etc/omxplayer/SIDEBYSIDE@${1}.config ]; then
  source /etc/omxplayer/SIDEBYSIDE@${1}.config
  #left
  omxplayer --aspect-mode fill -o hdmi --win 10,10,955,1070 $LEFT_OPTIONS & 
  LEFT_PID=$!
  wait_left &
  #right
  omxplayer --aspect-mode fill -o hdmi --win 965,10,1910,1070 $RIGHT_OPTIONS  &
  RIGHT_PID=$!
  wait_right &
else
  echo "missing config file /etc/omxplayer/SHEET@${1}.config"
  exit 1
fi

while true; do
  sleep 1
done
