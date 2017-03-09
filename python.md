Python packages are installed with `pip`. 

For our timer application, we have a single module dependency - pyglet. The rest of the required modules are included in default python installs.  Install pyglet as below:

```sudo pip3 install pyglet```

Note: pip is installed by default in Raspbian Jessie (but not Raspbian Wheezy or Jessie Lite). If the above command failed, you can install pip with apt:
```sudo apt-get install python3-pip```

(Note that we are installing Python 3 and using ```pip3``` to install Python 3 modules. Python 2 will shortly be ending active development and entering an extended maintenance-only phase.)
