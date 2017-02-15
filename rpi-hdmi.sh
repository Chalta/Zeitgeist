#!/bin/sh

# Enable and disable HDMI output on the Raspberry Pi
# Original code by AGWA: https://gist.github.com/AGWA/9874925

is_off ()
{
	tvservice -s | grep "TV is off" >/dev/null
}

case $1 in
	off)
		tvservice -o
	;;
	on)
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
	status)
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
