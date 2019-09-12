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

unset begin end VAR mac NID
read -p "Enter network ID [172.16.1.0]: " NID
NID=${NID:-172.16.1.0}
NID=$(echo $NID | cut -d"." -f1-3)
echo "Enter IP range of $NID.0 network"
read -p "begin: " begin
read -p "end: " end
if [[ -z "$begin" || -z "$end" ]]; then
	echo -e "\e[1;37mNO RANGE ENTERED \e[m"
else
	for i in `seq $begin $end`; do ping -c1 -W 1 $NID.$i &>/dev/null; \
		if [[ $? == 0 ]]; then 
			echo -e "[\e[1;36mSUCCESS\e[m] $NID.$i"
		else
			echo -e "[\e[1;31mFAILED\e[m]  $NID.$i"
		fi; 
	done;
fi
read -p "MAC [optional]:" mac
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
