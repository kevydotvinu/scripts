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

n=1
while [[ -f $HOME/Videos/screencast_$n.mp4 ]]
do
n=$((n+1))
done
filename="$HOME/Videos/screencast_$n.mp4"
ffmpeg -y \
-f x11grab \
-s 1366x768 \
-i :0.0 $filename
