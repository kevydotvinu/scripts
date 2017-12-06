#!/bin/bash
#
# NAME
# rxvt-config - configure rxvt-unicode
#
# SYNOPSIS
# bash ./rxvt-config.sh
# 
# This script is written for Debian based distributions
#
# CHANGELOG
# * Fri Nov 24 2017 Vinu K <kevy.vinu@gmail.com>
# - Original code

function rxvt_config {
local DIR=$(pwd)
local STAT=1
if [[ -e /etc/redhat-release ]]; then
	sudo yum install -y rxvt-unicode-256color-ml xsel
	STAT=$?
fi
if [[ -e /etc/debian_version ]]; then
	sudo apt install -y rxvt-unicode-256color xsel
	STAT=$?
fi
if [[ $STAT == 0 ]]; then
	mkdir -p ~/GitHub
	cd ~/GitHub
	git clone https://github.com/kevydotvinu/dotfiles.git
	echo "Xresources.rxvt copied" && cp dotfiles/.Xresources.rxvt ~/
	echo "Xresources.rxvt added to .xinitrc" && \
		echo "xrdb -merge ~/.Xresources.rxvt" >> ~/.xinitrc
	echo ".fonts copied" && cp -r dotfiles/.fonts/ ~/
	echo "Xresources updated" && xrdb -merge ~/.Xresources.rxvt
	cd
fi
sudo cp $DIR/clipboard /usr/lib/urxvt/perl/ || \
	sudo cp $DIR/clipboard /usr/lib64/urxvt/perl/
}

# Configure rxvt-unicode
rxvt_config
