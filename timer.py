#!/usr/bin/env python
# ----------------------------------------------------------------------------
# A fork derived from the fork of pyglet's timer.py by Luke Macken
#
# Copyright (c) 2006-2008 Alex Holkner
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
#  * Neither the name of pyglet nor the names of its
#    contributors may be used to endorse or promote products
#    derived from this software without specific prior written
#    permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
# ----------------------------------------------------------------------------

'''A full-screen hour:minute:second countdown timer.  

Specify two arguments when calling the script: 

e.g. timer.py [hours] [minutes]

Hours must be specified in the 24-hour clock. (e.g. 10pm = 22)

The script will then count down to that time on the current day. If that time is already past, it will count up in red.
'''

import sys
import pyglet
import datetime
import time
from datetime import timedelta

window = pyglet.window.Window(fullscreen=True)


#parse the arguments
targethour =        int(sys.argv[1])
targetminutes =     int(sys.argv[2])

class Timer(object):
    def __init__(self):
        self.start = ''
        self.label = pyglet.text.Label(self.start, font_name='Arial', font_size=400,
                                       x=window.width//2, y=window.height//2,
                                       anchor_x='center', anchor_y='center')
        self.reset()

    def reset(self):
        self.running = False
        self.label.text = self.start
        self.label.color = (240, 240, 240, 255)             #text color - corresponds with "dark" theme on PCO Live

    def update(self, dt):
        if self.running:
            now = datetime.datetime.now()
            target = datetime.datetime( now.year, now.month, now.day, targethour, targetminutes, 0) 
            delta =   target - now
            s = (delta.total_seconds())
            sign = "-" if s < 0 else ""
            s = abs(s)
            hours, remainder = divmod(s, 3600)
            minutes, seconds = divmod(remainder, 60)
            hoursdisplay = '%d:' % hours if hours > 0 else ""
            self.label.text = ((sign + hoursdisplay + '%02d:%02d' % (minutes, seconds)))

            if sign == "-":                                 #if timedelta is negative

                #self.running = False                       #time's up.
                self.label.color = (255, 94, 72, 255)	    #the over time color - corresponds with "dark" theme on PCO Live
                #self.label.text = 'OVER'                   #instead of counting up, it is possible to display a message instead

#have spacebar pause and unpause the timer, and "Esc" exits

@window.event
def on_key_press(symbol, modifiers):
    if symbol == pyglet.window.key.SPACE:
        if timer.running:
            timer.running = False
        else:
            timer.running = True
    elif symbol == pyglet.window.key.ESCAPE:
        window.close()


@window.event
def on_draw():
    pyglet.gl.glClearColor(0.1,0.1,0.1,255)                    #background color
    window.clear()
    timer.label.draw()	


timer = Timer()
timer.running = True                                           #default to timer running at startup
pyglet.clock.schedule_interval(timer.update, 1)
pyglet.app.run()
