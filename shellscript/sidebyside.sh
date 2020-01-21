#!/bin/bash
# Takes single argument
trap 'kill $RIGHT_PID; kill $LEFT_PID; exit' INT


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

if [ -f /etc/omxplayer/credentials.config ]; then source /etc/omxplayer/credentials.config; fi
if [ -f /etc/omxplayer/SIDEBYSIDE@${1}.config ]; then
  source /etc/omxplayer/SIDEBYSIDE@${1}.config
  #left
  omxplayer --aspect-mode Letterbox -o hdmi --win 0,0,960,1080 $LEFT_OPTIONS & 
  LEFT_PID=$!
  wait_left &
  #right
  omxplayer --aspect-mode Letterbox -o hdmi --win 960,0,1920,1080 $RIGHT_OPTIONS  &
  RIGHT_PID=$!
  wait_right &
else
  echo "missing config file /etc/omxplayer/SHEET@${1}.config"
  exit 1
fi
