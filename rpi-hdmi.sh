#!/bin/sh

# Enable and disable HDMI output on the Raspberry Pi
# Original code by AGWA: https://gist.github.com/AGWA/9874925

#Basic function to check if the tvservice (HDMI port) is currently off.
is_off ()
{
	tvservice -s | grep "TV is off" >/dev/null
}

#Script to turn the tvservice on, off or determine current status.
case $1 in

	# Shell script was called with request to turn HDMI service off. (i.e. The first argument, $1, is "off")
	off)
		#So do it. Turn it off.
		tvservice -o
	;;
	
	# Shell script was called with request to turn HDMI service on.	
	on)
		#So if it is off, turn it on.
		if is_off
		then
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
		echo "Usage: $0 on|off|status" >&2
		exit 2
	;;
esac

exit 0
