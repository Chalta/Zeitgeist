![zeigeist logo](https://github.com/Chalta/Zeitgeist/blob/master/zeitgeist_wallpaper.png "Zeitgeist Logo")

From German Zeitgeist, Zeit ‘time’ + Geist ‘spirit.’

[Planning Center LIVE](https://planning.center/2014/live-3/) on a lightweight Raspbian appliance. Scheduled delivery of web timers over HDMI in a low-cost, lightweight package using the Raspberry Pi 3 single-board computer.


Open-source and licensed under [GPLv3](https://github.com/Chalta/Zeitgeist/blob/master/LICENSE).

## Instructions:

(Commands in `code blocks` are to be entered in the [terminal](https://www.raspberrypi.org/documentation/usage/terminal/).)

1. Purchase a Raspberry Pi 3, Case, HDMI cable, USB Micro charging cable and Micro SD Card.
  * The official case is very well-designed, and also available in black. 
  * Purchasing a Micro-SD card with NOOBS preinstalled will also make your life easier. 16GB is more than enough space.
  * You can use your own USB keyboard and USB mouse or purchase one.  You can [check here for compatibility.](http://elinux.org/RPi_USB_Keyboards). Wireless is nice, but once you have VNC/SSH and WiFi set up, you can remote into the Pi headlessly.
  * You can Purchase an official PSU if you'd like. Alternately, You can use a high-quality smartphone USB charger (minimum 2A) or another device's USB port **at your own risk**, though this has worked well for many users.

2. [Install Raspbian directly or via NOOBS.](https://www.raspberrypi.org/documentation/installation/installing-images/)

3. Change the password for the default "Pi" user. [(Official Documentation)](https://www.raspberrypi.org/documentation/linux/usage/users.md)
  *  `passwd`
  
  * Follow the prompts (the default password is 'raspberry'), and choose a [strong, unique password](https://xkcd.com/936/). Write it on the Pi's case, or in another safe place that you will remember. This is going on your facility's network, and we're worried a more about remote intruders than local ones.
  
4. Configure settings
 *  `sudo raspi-config` **or** Menu -> Preferences -> Raspberry Pi Configuration
 *	Expand Filesystem \[1\] (**this step is critical**)
 * Boot to desktop, automatically logged in as user 'pi'  \[3-B4\]
 * Set localization (keyboard and system locale) \[5\]
 *	Enable SSH \[9-A4\]
 * Reboot when finished.
 
5.	Configure wifi settings. [Official Instructions](https://www.raspberrypi.org/documentation/configuration/wireless/)

6.	[Update and upgrade OS and software packages.](https://www.raspberrypi.org/documentation/configuration/wireless/) This will refresh the list of available packages, and upgrade installed packages to the latest versions. It will also update the kernel and the Raspberry Pi firmware to the latest stable versions.

  *  `sudo apt-get update && sudo apt-get dist-upgrade -y`
  
  *  This could be very fast or it could take a while (hours) if your hardware or NOOBS card are a few versions behind. Make some tea while you wait. Watch some Dr. Who. Choose a sufficiently British activity to hono**u**r the UK origins of your device.

        
7.	Install needed software.  
  *   Install the official packages. (See [below](https://github.com/Chalta/Zeitgeist/blob/master/README.md#software-details) for descriptions of each package)
  
      ```
      sudo apt-get install -y ttf-mscorefonts-installer x11-xserver-utils unclutter xdotool sed realvnc-vnc-server chromium-browser
      ```
  *  When this is complete, let's clean up the temporary files from the previous steps: `sudo apt-get clean`
  *  Reboot, then enable the VNC service as you did with SSH earlier in Step 4 of these instructions. [Official Documentation](https://www.raspberrypi.org/documentation/remote-access/vnc/)
  
8.	Configure sleep settings using the *nano* command line text editor.
  *  `sudo nano /etc/lightdm/lightdm.conf`
  
  * Find the line below in the in the [SeatDefaults] section. You will find two [SeatDefaults] sections. Make sure you edit the second instance.  Uncomment (remove the #) it and edit it as below:
  
  * `xserver-command=X -s 0 -dpms`. (Disables screen saver and power management. [[Reference]](https://www.x.org/archive/X11R6.8.0/doc/Xserver.1.html))
  * Press Control-O to save, and enter to confirm.
  
9.	Configure start up behaviour using the *nano* command line text editor.
  *   `sudo nano ~/.config/lxsession/LXDE-pi/autostart`
  
  * Append the lines found [here](https://github.com/Chalta/Zeitgeist/blob/master/%23autostart).
  
  * Note: You can press SHIFT-INSERT or right click the terminal window and select "copy" to copy text on the clipboard to the document at the current cursor location. Press *Control-O* to save, and *Enter* to confirm.
  
  * Reboot.

10.	Add shell functions. It's easiest to use the built-in LeafPad text editor for this step.
  * Place [this file](https://github.com/Chalta/Zeitgeist/blob/master/rpi-hdmi.sh) in /home/pi/rpi-hdmi.sh
  * Place [this file](https://github.com/Chalta/Zeitgeist/blob/master/pco_live.sh) in /home/pco_live.sh 
  * Then, make **both** files executable via chmod
       * `chmod +x /home/pi/rpi-hdmi.sh` and `chmod +x /home/pi/pco_live.sh` ) 
       *   **or** via the File Manager -> Properties -> Permissions menu and allow execution by owner.


11.	Schedule PCO Live and HDMI service in crontab
 *   Update cron tab `crontab -e` with the cron entries in [this file](https://github.com/Chalta/Zeitgeist/blob/master/%23cron).
 *   Edit the crontab entries to match your own service times and service type IDs. Example entries are provided. There are many helpful websites for [designing](https://crontab.guru/) and [validating](http://cron.schlitt.info/) crontab schedules.
 *   Note: Only schedule the rpi-HDMI script if you wish to turn off the monitor at certain times of day.

12. Activate the built-in systemd software/hardware watchdog to automatically reboot the Pi if hung.  [[Ref]](https://www.raspberrypi.org/forums/viewtopic.php?f=29&t=147501&p=972709#p972709)

  * `sudo nano /etc/systemd/system.conf`
  *  Uncomment and change these two lines from:
   
     ```shell
     #RuntimeWatchdogSec=0
     #ShutdownWatchdogSec=10min
     ```

  * to:
   
       ```shell
       RuntimeWatchdogSec=10
       ShutdownWatchdogSec=10min
       ```
       
   * Reboot your Pi for the changes to take effect, then check that the watchdog is working: 
   * `cat /var/log/syslog | grep watchdog`  (search for, then display any lines in the syslog that feature the word "watchdog")
   * Ouput should look like:
     
       ```
       raspberrypi kernel: [    3.885798] bcm2835-wdt 3f100000.watchdog: Broadcom BCM2835 watchdog timer
       raspberrypi systemd[1]: Hardware watchdog 'Broadcom BCM2835 Watchdog timer', version 0
       raspberrypi systemd[1]: Set hardware watchdog to 10s.
       raspberrypi CRON[482]: (pi) CMD (sudo /usr/sbin/service watchdog start)
       raspberrypi systemd[1]: Starting LSB: Start watchdog keepalive daemon...
       raspberrypi systemd[1]: Started LSB: Start watchdog keepalive daemon.

       ```
  * Your Pi will now automatically reboot if is hung or frozen for more than 10 seconds.  
     

13. Set up automatic login to Planning Center Online. Planning Center Online session cookies will eventually expire and you will be logged out. You can manually re-login when this happens (via VNC or a keyboard). But there are better, maintenance-free methods. The Lastpass extension for Chromium is free and can automatically log in to sites in a very secure manner.
   * It is **strongly** recommended that you use or create a special-purpose Planning Center user with the minimum-required permissions (viewer) for each service type. Do *not* use an "admin" level user. If you want to use this user for other applications such as ProPresenter integration or a Producer's iPad, "Editor" permissions are sufficient. This user will always be logged in on the Pi, so we want to limit the damage that could be done by anyone who accesses it and plugs in a keyboard.
   * Install the Lastpass extension from the Chromium web store.
   * Create a dedicated LastPass account. (We will only add the credentials of your generic limited-permissions PCO user.)
   * Login to the extension with your new LastPass account. Check off both "Remember User" and "Remember Password"
   * Visit the login page for PCO and login to you generic limited-permissions user. Save these credentials to Lastpass when prompted.
   * Then in the extension's *Preferences* menu, ensure both auto-logout options are unchecked. Check off "Automatically Fill Login Information"
   * In the extension's *Sites* menu, select the Planning Center Online entry you just saved, and edit it. Under "Advanced Options" for the site, enable "Auto-Login".
   * Click on *My Vault* in the extension's menu. Then access "Account Settings". Click "Show Advanced Settings", and in the "Re-prompt for Master Password" section, check off "Access a Site's Password".
   * Voila! We've now securely stored the password for your minimum permissions PCO user. Chromium on the Raspberry Pi will automatically login to this site without exposing the password.
   * If you already use LastPass personally or professionally, you could get fancy with [securely sharing passwords](https://blog.lastpass.com/2016/01/tips-for-securely-sharing-passwords.html/), but we'll leave that to the power users.

13. Log in to Planning Center Online.

   * Configure the timers to suit your requirements. as a recommended starting point:
   
         *  Set the layout to *"Countdown: Full"*
         *  Set the timer to *"Countdown: End item on time"*  (This option dynamically adjusts the countdown to keep your service on track.)
         *  Set the colour theme to *"Dark"*


15. Set your Raspbian desktop background to the official 1920x1080p [Zeitgeist wallpaper](https://github.com/Chalta/Zeitgeist/blob/master/zeitgeist_wallpaper.png)!

## Software Details

| Software | Description | Reference   |
|----------|-------------|--------------|
|ttf-mscorefonts-installer  | Optional: So webfonts render nicely | [Package Details](https://packages.debian.org/jessie/ttf-mscorefonts-installer)		|
|Chromium-browser	| Open Source Version of the Google Chrome Web Browser	| [Manual Page](https://manpages.debian.org/jessie/chromium/chromium.1.en.html) |
|x11-xserver-utils	| Display utilities needed to turn off screensaver, etc.	| [Package Details](https://packages.debian.org/sid/x11-xserver-utils) |
|unclutter	| Disables mouse pointer	 |[Manual Page](https://manpages.debian.org/jessie/unclutter/unclutter.1.en.html) |
|xdotool	| Simulates keyboard/mouse input	| [Manual Page](https://manpages.debian.org/jessie/xdotool/xdotool.1.en.html) |
|realvnc-vnc-server 	| Optional: Allows remote control and screensharing so you can control your RPi from another computer.	| [Manual Page](https://www.realvnc.com/docs/raspberry-pi.html#raspberry-pi-setup) |
|Sed | Stream editor for filtering and replacing text | [Manual Page](https://manpages.debian.org/jessie/sed/sed.1.en.html) |


## Remotely Accessing your Pi

### SSH

* From a Mac just type the following into Terminal `ssh pi@192.168.X.YY`, using the actual IP address of your RPi.

* On Windows, install [puTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/).


### VNC 

* On a Mac, just type the following into Terminal: `vnc://192.168.X.YY` using the actual IP address of your RPi.

* On Windows, install [RealVNC](https://www.realvnc.com/download/vnc/raspberrypi/). RealVNC is pre-licensed for Raspberry Pis and allows free cloud *and* direct connections for non-commercial users.

