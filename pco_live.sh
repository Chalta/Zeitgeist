#!/bin/sh
#
#---------------------------------------
# Description
#---------------------------------------
#
# Launch PCO Live in a Chromium web browser.
# Will show the next or currently live service for a specified service type, provided as an argument in the crontab.
#
#---------------------------------------
# License
#---------------------------------------
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

#---------------------------------------
# Instructions
#---------------------------------------

#Instructions: Put this script in /home/pi/PCOlive.sh
#Then, make it executable: chmod +x /home/pi/rpi-hdmi.sh
#Then update cron tab with the optional cron entries in this repository: https://github.com/Chalta/Zeitgeist/blob/master/cron

#---------------------------------------
# Code
#---------------------------------------

defaultservice="12345"  			#set this to your default service type ID. This will be used if no service id was specified by cron.



easter_weekend (){

retval=""
#basic function to find if today's date is between Maundy Thursday and Easter Sunday, inclusive.

#Determine the relevants dates, including the date that Easter was/will be in this calendar year.
today=$(date "+%Y%m%d")					#Today's date
easter=$(date --date="$(ncal -e)" "+%Y%m%d") 		#Easter Sunday, calculated via ncal -e
maundy=$(date --date="$easter -3 days" "+%Y%m%d") 	#Maundy Thursday - 3 days before Easter

#debugging
#echo $easter
#echo $maundy
#echo $today

if [ "$today" -le "$easter" ]  						#Easter is coming up or today
	then 
		if [ "$today" -ge "$maundy" ];				#Maundy Thursday is past or today
		then		
    			#echo "Easter Weekend is in the Present"		#Today's date is between Maundy Thursday and Easter Sunday, inclusive.
			retval="Present"
		
		
		else 
			#echo "Easter Weekend is in the Future"			#Today's date is before Maundy Thursday.
			retval="Future"
		fi
	else
		#echo "Easter Weekend is in the Past"				#Today's date is after Easter Sunday.
		retval="Past"
fi

echo "$retval"

} 



#If service type is specified as an argument, use that ID. Otherwise, use the default ID specified above.
servicetype=${1:-${defaultservice}};   
		#echo $servicetype;   #for debugging purposes

#script was called with the "good friday" argument set. If it is Easter Weekend, allow the script to continue.




if [ X"$2" = X"goodfriday" ] 
	then 
	#echo "string called"
	#echo "$easter_weekend"
	retval=$( easter_weekend )
	#echo $retval	

		if [ $retval != "Present"  ]	#If it is not easter weekend...
		then 


			echo 				"It's not Easter! Aborting script!"
			exit 0				#exit without doing anything.
		fi
fi






#Operate on the first display on the local machine
DISPLAY=:0

#returns the first line (head- 1) in a search for the window ID of the Chromium browser.
WID=$(xdotool search --onlyvisible --class chromium|head -1)



if [ -z ${WID} ] 			#Chromium is not open. 
then echo "Chromium is not open! Opening Chromium."	#let the user know what happened.

#Chrome will display an annoying "Restore last session" popup if it crashed previously.
#We don't care. So let's make it think it always closed normally. 
#This is suuuper kludgy as we're essentially editing a log file with a search and replace function in a stream editor.
#However, it seems that Chromium has removed any other way to do it with startup CLI flags.
#Note: The --incognito startup flag is common for web kiosks, but that won't preserve the cookies that keep us logged in to PCO.

sed -i 's/Crashed/normal/g' "/home/pi/.config/chromium/Profile 1/Preferences"    #Opens the preferences file and replaces the last session "Crashed" status, with "normal" status.          

#give the above script a little bit of time to execute.
sleep 3s 

#start Chromium and load the correct web address in fullscreen mode
chromium-browser --start-fullscreen --disable-infobars https://services.planningcenteronline.com/service_types/"$servicetype"/plans/after/today/live > /dev/null 2>&1 &

#give the browser some time to open before moving on to the next step
sleep 4s

#Since Chromium is open now, get the window ID
WID=$(xdotool search --onlyvisible --class chromium|head -1)
fi





#Opens the address bar of Chromium, types a URL and presses enter
xdotool windowactivate ${WID}
xdotool key F11
sleep 2s
xdotool key ctrl+l
sleep 1s
xdotool type 'https://services.planningcenteronline.com/service_types/'"$servicetype"'/plans/after/today/live'
xdotool key Return
sleep 2s
xdotool key F11


#turn on the HDMI output, just in case it was off.
sudo /home/pi/rpi-hdmi.sh  on /dev/null 2>&1 &

exit
