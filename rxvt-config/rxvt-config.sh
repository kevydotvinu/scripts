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
sudo apt install -y rxvt-unicode-256color xsel
type rxvt-unicode
if [[ $? == 0 ]]; then
	mkdir ~/GitHub
	cd ~/GitHub
	git clone https://github.com/kevydotvinu/dotfiles.git
	echo "Xresources.rxvt copied" && cp dotfiles/.Xresources.rxvt ~/
	echo "Xresources.rxvt added to .xinitrc" && \
		echo "xrdb -merge ~/.Xresources.rxvt" >> ~/.xinitrc
	echo ".bashrc copied" && cp dotfiles/.bashrc ~/
	echo ".bash_funcs copied" && cp dotfiles/.bash_funcs ~/
	echo ".bash_alias copied" && cp dotfiles/.bash_alias ~/
	echo ".fonts copied" && cp -r dotfiles/.fonts/ ~/
	echo "Xresources updated" && xrdb -merge ~/.Xresources.rxvt
	sudo update-alternatives --config x-terminal-emulator
	cd
fi
sudo cp $DIR/clipboard /usr/lib/urxvt/perl/
}

# Configure rxvt-unicode
rxvt_config
