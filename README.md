# Zeitgeist
Use a Raspberry Pi 3 to display service countdown timers in HD over HDMI from Planning Center Services Live 3.0.


Instructions:

1. Install Raspbian.
2. Change the password for the default "Pi" user.

3. Configure settings
  *  
        ```shell
        sudo raspi-config
        ```
 * Set localization (keyboard and system locale)
 *	Enable SSH
 *	Expand root partition
 *	Set autologin on console (B2)
 * Scroll down to boot_behavior and hit enter. Make sure “Yes” is marked, hit enter again.
4.	Configure wifi settings.
5.	Update and upgrade
  *  
        ```shell
        sudo apt-get update && sudo apt-get upgrade -y`
        ```
6.	Install software. 
  *  
      ```shell
      sudo apt-get install ttf-mscorefonts-installer x11-xserver-utils unclutter chromium xdotool tightvncserver watchdog
      ```
7.	Configure sleep settings.
  *  `sudo nano /etc/lightdm/lightdm.conf`
  * Uncomment (remove the #) and edit this line in the [SeatDefaults] section:
  * `xserver-command=X -s 0 -dpms`
8.	[Configure start up behaviour.](https://github.com/Chalta/Zeitgeist/blob/master/autostart)
9.	[Add ability to turn off HDMI signal at certain dates/times.] (https://github.com/Chalta/Zeitgeist/blob/master/rpi-hdmi.sh)
10.	[Insert and configure script to run PCOLive across multiple service types on a preset schedule without human intervention:] (https://github.com/Chalta/Zeitgeist/blob/master/PCOlive.sh)
11.	[Schedule PCO Live and HDMI service in crontab](https://github.com/Chalta/Zeitgeist/blob/master/cron)
12. [Configure watchdog daemon to automatically reboot the Pi if hung.](https://github.com/Chalta/Zeitgeist/blob/master/watchdog)


| Software | Description | Man Page  |
|----------|-------------|--------------|
|ttf-mscorefonts-installer  | So webfonts render nicely | 		|
|Chromium	|Browser	||
|x11-xserver-utils	| Display utilities needed to turn off screensaver, etc.	||
|unclutter	| Disables mouse pointer	Unclutter Man Page | http://manpages.ubuntu.com/manpages/zesty/en/man1/unclutter.1.html |
|xdotool	| Fake keyboard/mouse input	||
|tightvncserver	| Allows remote control and screensharing.	||
|Watchdog ||		https://linux.die.net/man/8/watchdog |


