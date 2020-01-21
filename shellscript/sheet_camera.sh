#/bin/bash

# Takes single argument
if [ -z $1 ]; then
  echo "Requires camera name"
  exit 1
fi

if [ -f /etc/omxplayer/credentials.config ]; then source /etc/omxplayer/credentials.config; fi
if [ -f /etc/omxplayer/SHEET@${1}.config ]; then 
  source  /etc/omxplayer/SHEET@${1}.config 
  #Run omxplayer
  omxplayer -o hdmi --win 0,0,1920,1080 ${OMXPLAYER_OPTIONS} ${RTSP_FEED}
else
  echo "missing config file /etc/omxplayer/SHEET@${1}.config"
  exit 1
fi
