#script assumes Chromium is already open and fullscreen

username="username"
password="password"


#Operate on the first display on the local machine
DISPLAY=:0

#returns the first line (head- 1) in a search for the window ID of the Chromium browser.
WID=$(xdotool search --onlyvisible --class chromium|head -1)

#Opens the address bar of Chromium, and finds the current URL
xdotool windowactivate ${WID}
xdotool key F11                                           #exit fullscreen
sleep 2s
xdotool key ctrl+l                                        #open address bar
sleep 1s
xclip -selection clipboard                                #copy the current address bar contents (URL) to xclip
echo -n xclip                                             #output the contents of xclip to terminal for error-checking purposes
xclip -out | grep 'https://accounts.planningcenteronline.com/login'     #are we on the login page?

#if we aren't logged in...

#comment this block out for now
if 1 -eq 2
then

xdotool key Tab                                           #tab into username field
#enter username
xdotool type "$username"
xdotool key Tab                                           #tab into password field
#enter password
xdotool type "$password"   
xdotool key Return                                        #submit login information
xdotool key F11 
fi
