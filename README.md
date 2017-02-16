# Zeitgeist

From German Zeitgeist, Zeit ‘time’ + Geist ‘spirit.’

Use a Raspberry Pi 3 to display highly-reliable automated service countdown timers in HD over HDMI from [Planning Center Services Live 3.0](https://planning.center/2014/live-3/).


## Instructions:

(Commands in `code blocks` are to be entered in the [terminal](https://www.raspberrypi.org/documentation/usage/terminal/).)

1. Purchase a Raspberry Pi 3, Case, HDMI cable, USB Micro charging cable and Micro SD Card.

1. [Install Raspbian directly or via NOOBS.](https://www.raspberrypi.org/documentation/installation/installing-images/)

2. Change the password for the default "Pi" user. [(Official Documentation)](https://www.raspberrypi.org/documentation/linux/usage/users.md)
  *  `password`
  
  * Follow the prompts, and choose a [strong password](https://xkcd.com/936/). Write it on the Pi's case if desired - unless you use a hardwired ethernet connection, this is going on your WiFi network, and we're worried a lot more about remote intruders than local ones.
  
3. Configure settings
 *  `sudo raspi-config`
 * Set localization (keyboard and system locale)
 
 *	Enable SSH
 
 *	Expand root partition
 
 * Select **Enable Boot to Desktop/Scratch** from the menu and press Enter
 
 *  Select **Desktop Login as user pi at the Graphical Desktop**.

4.	Configure wifi settings. [Official Instructions](https://www.raspberrypi.org/documentation/configuration/wireless/)
5.	[Update and upgrade OS and software packages.](https://www.raspberrypi.org/documentation/configuration/wireless/) This will refresh the list of available packages, and upgrade installed packages to the latest versions. It will also update the kernel and the Raspberry Pi firmware to the latest stable versions.
  *  `sudo apt-get update && sudo apt-get dist-upgrade -y`
        
6.	Install new software.  (See below for descriptions of each package)
  * `sudo apt-get install ttf-mscorefonts-installer x11-xserver-utils unclutter chromium xdotool tightvncserver watchdog`
      
7.	Configure sleep settings.
  *  `sudo nano /etc/lightdm/lightdm.conf`
  
  * Find the line below in the in the [SeatDefaults] section. Uncomment (remove the #) it and edit it as below :
  
  * `xserver-command=X -s 0 -dpms`
  
8.	[Configure start up behaviour.](https://github.com/Chalta/Zeitgeist/blob/master/autostart)

9.	[Add ability to turn off HDMI signal at certain dates/times.] (https://github.com/Chalta/Zeitgeist/blob/master/rpi-hdmi.sh)

10.	[Insert and configure script to run PCOLive across multiple service types on a preset schedule without human intervention:] (https://github.com/Chalta/Zeitgeist/blob/master/PCOlive.sh)

11.	[Schedule PCO Live and HDMI service in crontab](https://github.com/Chalta/Zeitgeist/blob/master/cron)

12. [Configure watchdog daemon to automatically reboot the Pi if hung.](https://github.com/Chalta/Zeitgeist/blob/master/watchdog)


## Software Details

| Software | Description | Reference   |
|----------|-------------|--------------|
|ttf-mscorefonts-installer  | Optional: So webfonts render nicely | [Package Details](https://packages.debian.org/jessie/ttf-mscorefonts-installer)		|
|Chromium	| Web Browser	| [Manual Page](https://manpages.debian.org/jessie/chromium/chromium.1.en.html) |
|x11-xserver-utils	| Display utilities needed to turn off screensaver, etc.	| [Package Details](https://packages.debian.org/sid/x11-xserver-utils) |
|unclutter	| Disables mouse pointer	 |[Manual Page](https://manpages.debian.org/jessie/unclutter/unclutter.1.en.html) |
|xdotool	| Simulates keyboard/mouse input	| [Manual Page](https://manpages.debian.org/jessie/xdotool/xdotool.1.en.html) |
|tightvncserver	| Optional: Allows remote control and screensharing so you can control your RPi from another computer.	| [Manual Page](https://manpages.debian.org/jessie/tightvncserver/tightvncserver.1.en.html) |
|Watchdog | Reboots automatically if system is hung. |		[Manual Page](https://manpages.debian.org/jessie/python-watchdog/watchdog.3.en.html) |


## Remotely Accessing your Pi

### SSH

* From a Mac just type the following into Terminal `ssh pi@192.168.X.YY`, using the actual IP address of your RPi.

* On Windows, install [puTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/).


### VNC 

* On a Mac, just type the following into Terminal: `vnc://192.168.X.YY` using the actual IP address of your RPi.

* On Windows, install [RealVNC](https://www.realvnc.com/).

