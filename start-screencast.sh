#!/bin/bash
#
# NAME
#	Screencast Script
#
# SYNOPSIS
#	bash start-screencast.sh
#
# DESCRIPTION
#	It records present screen in mp4 format
#
# CHANGELOG
#	- Sat Feb 10 2018 <kevy.vinu@gmail.com>
#	* Original Code

notify-send "Record" "Screencast starting in 5 sec"
sleep 7s
n=1
while [[ -f $HOME/Videos/screencast_$n.mp4 ]]
do
n=$((n+1))
done
filename="$HOME/Videos/screencast_$n.mp4"
ffmpeg -y \
-f x11grab \
-s `xrandr | grep \* | cut -d' ' -f4` \
-i :0.0 $filename
