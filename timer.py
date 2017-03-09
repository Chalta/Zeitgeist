#!/usr/bin/env python
# ----------------------------------------------------------------------------
# A fork of pyglet's timer.py by Luke Macken
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

'''A full-screen minute:second countdown timer.  Leave it in charge of your conference
lighting talks.
Once there is 5 minutes left, the timer goes red.  This limit is easily
adjustable by hacking the source code.
Press spacebar to start, stop and reset the timer.
'''

import sys
import pyglet


window = pyglet.window.Window(fullscreen=True)


COUNTDOWN = int(sys.argv[1])


class Timer(object):
    def __init__(self):
        self.start = '%s:00' % COUNTDOWN
        self.label = pyglet.text.Label(self.start, font_size=430,
                                       x=window.width//2, y=window.height//2,
                                       anchor_x='center', anchor_y='center')
        self.reset()

    def reset(self):
        self.time = COUNTDOWN * 60
        self.running = False
        self.label.text = self.start
        self.label.color = (240, 240, 240, 255) 	       #text color

    def update(self, dt):
        if self.running:
            self.time -= dt									#self.time = self.time - number of seconds defined by pyglet.clock.schedule_interval below
            m, s = divmod(self.time, 60)					#divide self.time by 60. The quotient is minutes, the remainder is seconds.
            self.label.text = '%02d:%02d' % (m, s)			#substitutes m and s into the provided format using the % string substitution character
          #  if m < 0:
            
     
          #      self.running = False		                #time's up.
          #      self.label.color = (255, 94, 72, 255)		#the warning color		
          #      self.label.text = 'OVER'

#have spacebar stop and start the timer, and "Esc"	exit		
				
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
    pyglet.gl.glClearColor(0.1,0.1,0.1,255)				#background color
    window.clear()
    timer.label.draw()	


timer = Timer()
timer.running = True										#default to timer running	
pyglet.clock.schedule_interval(timer.update, 1)
pyglet.app.run()
