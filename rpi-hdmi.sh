#!/bin/sh

#---------------------------------------
# Description
#---------------------------------------

# Enable and disable HDMI output on the Raspberry Pi
# Original code by AGWA: https://gist.github.com/AGWA/9874925

#---------------------------------------
# Instructions
#---------------------------------------

#Instructions: Put this script in /home/pi/rpi-hdmi.sh
#Then, make it executable: chmod +x /home/pi/rpi-hdmi.sh
#Then update cron tab with the optional cron entries in this repository.

#---------------------------------------
# Code
#---------------------------------------


#Basic function to check if the tvservice (HDMI port) is currently off.
is_off ()
{
	tvservice -s | grep "TV is off" >/dev/null
}

#Script to turn the tvservice on, off and/or determine current status.
case $1 in

	# The shell script was called with request to turn HDMI service off. (i.e. The first argument, $1, is "off")
	off)
		#So do it. Turn it off.
		tvservice -o
	;;
	
	# Shell script was called with request to turn HDMI service on.	
	on)
		#So if it is off, turn it on.
		if is_off
		then
			#Reinitialize X11
			tvservice -p
			curr_vt=`fgconsole`
			if [ "$curr_vt" = "1" ]
			then
				chvt 2
				chvt 1
			else
				chvt 1
				chvt "$curr_vt"
			fi
		fi
	;;

	# Shell script was called with request for current status	
	status)
		#So announce the current status of the HDMI service.
		if is_off
		then
			echo off
		else
			echo on
		fi
	;;
	*)
	#If no on|off|status argument was specified, provide basic instruction for usage of this script
		echo "Usage: $0 on|off|status" >&2
		exit 2
	;;
esac

exit 0
