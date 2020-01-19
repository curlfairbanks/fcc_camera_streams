Scripts for FCC cameras


### Pre-req

1. Pull this repo down to the raspi
2. Run the intall.sh script as root ... sudo is your friend
3. create the `/etc/omxplayer/` directory and populate it with correct configurations for each camera.  Config files should match service names:
Ex: `SHEET@1NR -> camera 1 near`  `SHEET@2FR -> camera 2 far` See the Conflicts directive in the systemd template service `SHEET@.service` for full list of supported cam names.
4. start the camera_control service: `sudo systemctl start camera_control`

### Manual Channel Up
1. Optionally, start a journalctl tail in seperate terminal to watch camera_control log output: `journalctl -f -u camera_control`
2. Check running camera service: `systemctl list-units |grep SHEET`
3. Run: `sudo bash -c 'echo "u" > /tmp/cameractl.fifo'`
4. Confirm running camera service has channged: `systemctl list-units |grep SHEET`

### GPIO Channel Up
1. Optionally, start a journalctl tail in seperate terminal to watch camera_control log output: `journalctl -f -u camera_control`
2. Check running camera service: `systemctl list-units |grep SHEET`
3. Press button connected to GPIO17 pin
4. Confirm running camera service has channged: `systemctl list-units |grep SHEET`

### Manual Channel Down
1. Optionally, start a journalctl tail in seperate terminal to watch camera_control log output: `journalctl -f -u camera_control`
2. Check running camera service: `systemctl list-units |grep SHEET`
3. Run: `sudo bash -c 'echo "d" > /tmp/cameractl.fifo'`
4. Confirm running camera service has channged: `systemctl list-units |grep SHEET`

### GPIO Channel Down
1. Optionally, start a journalctl tail in seperate terminal to watch camera_control log output: `journalctl -f -u camera_control`
2. Check running camera service: `systemctl list-units |grep SHEET`
3. Press button connected to GPIO27 pin
4. Confirm running camera service has channged: `systemctl list-units |grep SHEET`


