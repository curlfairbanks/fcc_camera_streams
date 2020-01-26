#/bin/bash

CREDDIR="/etc/curl_cam/creds"

# Takes single argument
if [ -z $1 ]; then
  echo "Requires camera name"
  exit 1
fi

if [ -f $CREDDIR/credentials.config ]; then source $CREDDIR/credentials.config; fi
if [ -f /etc/omxplayer/SHEET@${1}.config ]; then 
  source  /etc/omxplayer/SHEET@${1}.config 
  #Run omxplayer
  omxplayer -o hdmi --win 0,0,1920,1080 ${OMXPLAYER_OPTIONS} ${RTSP_FEED}
else
  echo "missing config file /etc/omxplayer/SHEET@${1}.config"
  exit 1
fi
