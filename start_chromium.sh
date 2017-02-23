#!/bin/sh
#---------------------------------------
# Description
#---------------------------------------

# Start Chromium on reboot.

#---------------------------------------
# Instructions
#---------------------------------------

#Instructions: Put this script in /home/pi/start_chromium.sh
#Then, make it executable: chmod +x /home/pi/start_chromium.sh

#---------------------------------------
# Code
#---------------------------------------

#First, make sure chrome always thinks it closed cleanly, so we don't see "Restore last session? Chromium didn't shut down correctly".       


#replaces the last session "Crashed" status, with "normal".
#This is suuuper kludgy, but it seems that Chromium has removed any other way to do it with startup flags.
#Many other users use incognito, but that won't preserve the cookies that keep us logged in to PCO.
sed -i 's/Crashed/normal/g' "/home/pi/.config/chromium/Profile 1/Preferences"             

#give the above script a little bit of time to execute.
sleep 3s 

#load a default web address in fullscreen mode
chromium-browser --start-fullscreen --disable-infobars https://services.planningcenteronline.com/service_types/57683/plans/after/today/live
