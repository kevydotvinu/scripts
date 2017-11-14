#!/bin/bash
##
## Copyright 2017 kevydotvinu.github.com
##
## NAME
##     Fancy Terminal - terminal styling
## SYNOPSIS
##     bash fancyterminal.sh
##
##     This script is written for Debian 9 (Stretch)
##
## DESCRIPTION
##     This script is the configuration script to build a fancy terminal
##
## CHANGELOG
##   * Tue Oct 23 2017 Vinu K <kevy.vinu@gmail.com>
##   - original code

function install_packages {
	sudo apt-get install python-pip git zsh vim-gtk
        sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
        pip install --user git+git://github.com/Lokaltog/powerline
}

function append_conf_files {
cat << EOF | tee -a ~/.zshrc
	if [ -d "$HOME/.local/bin" ]; then
	    PATH="$HOME/.local/bin:$PATH"
	fi
EOF
cat << EOF | tee -a ~/.zshrc
	if [[ -r ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
	source ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
    fi
EOF
}

function fetch_conf_files {
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
	wget -O ~/.zshrc https://raw.githubusercontent.com/kevydotvinu/dotfiles/master/.zshrc
	wget -O ~/.tmux.conf https://raw.githubusercontent.com/kevydotvinu/dotfiles/master/.tmux.conf
	wget -O ~/.vimrc https://raw.githubusercontent.com/kevydotvinu/dotfiles/master/.vimrc
	mkdir -p ~/.vim/colors
	wget -O ~/.vim/colors/lucario.vim https://raw.githubusercontent.com/kevydotvinu/dotfiles/master/.vim/colors/lucario.vim
	wget -O ~/.bash_funcs https://raw.githubusercontent.com/kevydotvinu/dotfiles/master/.bash_funcs
	wget -O ~/.bash_alias https://raw.githubusercontent.com/kevydotvinu/dotfiles/master/.bash_alias
}

function install_vim_plugin {
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

type powerline &>/dev/null
if [ $? == 1 ] ; then
	install_packages
	#append_conf_files
	fetch_conf_files
	install_vim_plugin
	echo "SUCCESS"
else
	echo "ALREADY INSTALLED"
fi

