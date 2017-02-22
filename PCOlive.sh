#!/bin/sh

#---------------------------------------
# Description
#---------------------------------------

# Launch PCO Live in a Chromium web browser.
# Will show the next or currently live service for a specified service type, provided as an argument in the crontab.

#---------------------------------------
# Instructions
#---------------------------------------

#Instructions: Put this script in /home/pi/PCOlive.sh
#Then, make it executable: chmod +x /home/pi/rpi-hdmi.sh
#Then update cron tab with the optional cron entries in this repository: https://github.com/Chalta/Zeitgeist/blob/master/cron

#---------------------------------------
# Code
#---------------------------------------

#If argument goodfriday is set but today is not (Good Friday or Maundy Thursday), exit code.
Case $2 in
	goodfriday)
  
  #this code needs to be finalized. this is test code.
	if [[ $(date '+%a') != ncal -e -2 days ]]
	
  
  then
    exit 0
	fi

#Otherwise *, run code normally.
	*) 
  
#Operate on the first display on the local machine
DISPLAY=:0

#returns the first line (head- 1) in a search for the window ID of the Chromium browser.
WID=$(xdotool search --onlyvisible --class chromium|head -1)

#Opens the address bar of Chromium, types a URL and presses enter
xdotool windowactivate ${WID}
xdotool key ctrl+l
xdotool type 'https://services.planningcenteronline.com/service_types/$1/plans/after/today/live'
xdotool key Return



