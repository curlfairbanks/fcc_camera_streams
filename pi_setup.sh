#!/bin/bash

CURLREPO="https://github.com/curlfairbanks/fcc_camera_streams.git"
CAMDIR="/home/pi/curl_cam"
CONFIG="/boot/config.txt"
CMDLINE="/boot/cmdline.txt"
PACKAGES="vim screen fbi"
THEME="/usr/share/plymouth/themes/pix/pix.script"

NC=`tput sgr0`
GREEN=`tput setaf 2`
RED=`tput setaf 1`
BLUE=`tput setaf 4`
YELLOW=`tput setaf 3`

apt-get update
apt-get upgrade -y

apt-get install $PACKAGES -y

#Cloning the curl_cam repository
echo -e "${YELLOW}Cloning the curl_cam repository...${NC}"
git clone $CURLREPO $CAMDIR
chown -R pi:pi $CAMDIR

#Make our default config dir for omxplayer
echo -e -n "${YELLOW}Making /etc/omxplayer directory... ${NC}"
mkdir /etc/omxplayer
echo -e " ${GREEN}[DONE]${NC}"

#copy splash image and backup original
echo -e -n "${YELLOW}Backing up plymouth theme default splash image...${NC}"
cp /usr/share/plymouth/themes/pix/splash.png /usr/share/plymouth/themes/pix/splash.png.default
echo -e " ${GREEN}[DONE]${NC}"

echo -n "Copying custom splash image..."
cp $CAMDIR/back.png /usr/share/plymouth/themes/pix/splash.png
cp $CAMDIR/back.png /etc/omxplayer/
echo -e " ${GREEN}[DONE]${NC}"

echo "Removing splash text from theme file..."
sed -i "s/message_sprite = Sprite();/#message_sprite = Sprite();/" $THEME
sed -i "s/message_sprite.SetPosition(screen_width * 0.1, screen_height * 0.9, 10000);/#message_sprite.SetPosition(screen_width * 0.1, screen_height * 0.9, 10000);/" $THEME
sed -i "s/my_image = Image.Text(text, 1, 1, 1);/#my_image = Image.Text(text, 1, 1, 1);/" $THEME
sed -i "s/message_sprite.SetImage(my_image);/#message_sprite.SetImage(my_image);/" $THEME

#Set CLI for boot
echo -n "${YELLOW}Setting system to boot CLI and disabling desktop${NC}"
/usr/bin/raspi-config nonint do_boot_behaviour B1
echo " ${GREEN}[DONE]${NC}"

echo -e "${YELLOW}Checking config.txt items....${NC}"

if grep -Fq "gpu_mem" $CONFIG
then
	echo -n "gpu_mem exists..."
	sed -i "/gpu_mem/c\gpu_mem=512" $CONFIG
	echo -e " ${GREEN}[UPDATED SETTING]${NC}"
else
	echo -n "gpu_mem not found..."
	echo "gpu_mem=512" >> $CONFIG
	echo -e " ${GREEN}[ADDED]${NC}"
fi

if grep -Fq "disable_splash" $CONFIG
then
	echo -n "disable_splash exists..."
	sed -i "s/disable_splash=0/disable_splash=1/" $CONFIG
	echo -e " ${GREEN}[UPDATED SETTING]${NC}"
else
	echo -n "disable_splash not found..."
	echo "disable_splash=1" >> $CONFIG
	echo -e " ${GREEN}[ADDED]${NC}"
fi
echo ""

#Edit cmdline.txt settings
echo "${YELLOW}Checking cmdline.txt items......${NC}"
if grep -Fq "console=tty" $CMDLINE
then
	echo -n "console found..."
	sed -i "s/console=tty1/console=tty3/" $CMDLINE
	echo -e " ${GREEN}[UPDATED SETTING]${NC}"
else
	echo -n "console not found..."
	sed -i "$ s/$/ console=tty3/" $CMDLINE
	echo -e " ${GREEN}[ADDED]${NC}"
fi

if grep -Fq "splash" $CMDLINE
then
        echo -e "splash found... ${RED}nothing to do${NC}"
else
        echo -n "splash not found..."
	sed -i "$ s/$/ splash/" $CMDLINE
	echo -e " ${GREEN}[ADDED]${NC}"
fi

if grep -Fq "quiet" $CMDLINE
then
        echo "quiet found... ${RED}nothing to do${NC}"
else
        echo -n "quiet not found..."
	sed -i "$ s/$/ quiet/" $CMDLINE
	echo -e " ${GREEN}[ADDED]${NC}"
fi

if grep -Fq "logo.nologo" $CMDLINE
then
        echo "logo.nologo found... ${RED}nothing to do${NC}"
else
        echo -n "logo.nologo not found..."
        sed -i "$ s/$/ logo.nologo/" $CMDLINE
	echo -e " ${GREEN}[ADDED]${NC}"
fi

if grep -Fq "vt.global_cursor_default=0" $CMDLINE
then
	echo "vt.global_cursor_default found... ${RED}nothng to do${NC}"
else
	echo -n "vt.global_cursor_default not found..."
	sed -i "$ s/$/ vt.global_cursor_default=0/" $CMDLINE
	echo -e " ${GREEN}[ADDED]${NC}"
fi

echo ""

#Set the hostname to a new default
echo -n "${YELLOW}Setting hostname to [curlcampi]...."
/usr/bin/raspi-config nonint do_hostname 'curlcampi'
echo -e " ${GREEN}[DONE]${NC}"

#SSH is probably already enabled if we are running this script. But lets be sure.
echo ""
echo -e "${YELLOW}Enabling SSH service...${NC}"
/bin/systemctl enable ssh
/bin/systemctl start ssh
echo ""

#Installing curl_cam
echo -e -n "${YELLOW}Installing camera control script to /usr/local/bin ...${NC}"
cp $CAMDIR/python/camera_control /usr/local/bin
cp $CAMDIR/python/camera_netcontrol /usr/local/bin
echo -e " ${GREEN}[DONE]${NC}"

echo -e -n "${YELLOW}Install camera shell scripts...${NC}"
cp $CAMDIR/shellscript/sidebyside.sh /usr/local/bin
cp $CAMDIR/shellscript/sheet_camera.sh /usr/local/bin
echo -e " ${GREEN}[DONE]${NC}"

echo -e -n "${YELLOW}Installing systemd services into /etc/systemd/system ...${NC}"
cp $CAMDIR/systemd/SHEET@.service /etc/systemd/system
cp $CAMDIR/systemd/SIDEBYSIDE@.service /etc/systemd/system
cp $CAMDIR/systemd/camera_control.service /etc/systemd/system
cp $CAMDIR/systemd/camera_netcontrol.service /etc/systemd/system
echo -e " ${GREEN}[DONE]${NC}"

echo -e -n "${YELLOW}Reloading system daeamon...${NC}"
/bin/systemctl daemon-reload
echo -e " ${GREEN}[DONE]${NC}"

echo -e "${YELLOW}Setting camera_control to start at boot..."
/bin/systemctl enable camera_control
/bin/systemctl enable camera_netcontrol
echo "${GREEN}[DONE]${NC}"

echo ""

echo ""
echo -e "${RED}"
echo -e "\_   ___ \ __ _________|  | |__| ____    ____  "
echo -e "/    \  \/|  |  \_  __ \  | |  |/    \  / ___\ "
echo -e "\     \___|  |  /|  | \/  |_|  |   |  \/ /_/  >"
echo -e " \______  /____/ |__|  |____/__|___|  /\___  / "
echo -e "        \/                          \//_____/  "
echo -e "${GREEN}__________               __           ._."
echo -e "\______   \ ____   ____ |  | __  _____| |"
echo -e " |       _//  _ \_/ ___\|  |/ / /  ___/ |"
echo -e " |    |   (  <_> )  \___|    <  \___ \ \|"
echo -e " |____|_  /\____/ \___  >__|_ \/____  >__"
echo -e "        \/            \/     \/     \/ \/"

echo "${BLUE}"
echo "That's it! This Pi is setup for curl cam"
echo "Time to reboot and setup config files"
echo -e "${NC}"
