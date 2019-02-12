# #!/bin/bash
#
# NAME
#	Find wheather target IP is up
#
# SYNOPSIS
#	bash find-target-ip.sh
#
# DESCRIPTION
#	It pings each machines and gives current state
#
# CHANGELOG
#	* Wed Jan 24 2018 <kevy.vinu@gmail.com>
#	- Original code

unset begin end VAR mac
echo "Enter IP range of 172.16.1.0 network"
read -p "begin: " begin
read -p "end: " end
if [[ -z "$begin" || -z "$end" ]]; then
	echo -e "\e[1;37mNO RANGE ENTERED \e[m"
else
	for i in `seq $begin $end`; do ping -c1 -W 1 172.16.1.$i &>/dev/null; \
		if [[ $? == 0 ]]; then 
			echo -e "[\e[1;36mSUCCESS\e[m] 172.16.1.$i"
		else
			echo -e "[\e[1;31mFAILED\e[m]  172.16.1.$i"
		fi; 
	done;
fi
read -p "MAC: " mac
if [[ -z "$mac" ]]; then
	echo -e "\e[1;37mNO MAC \e[m"
else
	VAR=`arp | grep $mac | awk '{print $1}'`
fi
if [[ ! -z $VAR ]]; then
	echo -e "[\e[1;34mTARRGET\e[m] $VAR";
else
	echo -e "[\e[1;34mTARRGET\e[m] \e[1;37mUNKNOWN \e[m";
fi
