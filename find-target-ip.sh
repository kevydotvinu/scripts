#!/bin/bash
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

echo "Enter IP range of 172.16.1.0 network"
read -p "begin: " begin
read -p "end: " end
for i in `seq $begin $end`; do ping -c1 -W 1 172.16.1.$i &>/dev/null; \
if [[ $? == 0 ]]; then 
echo -e "[\e[1;36mSUCCESS\e[m] 172.16.1.$i"
#echo -e "172.16.1.$i [\e[1;36m SUCCESS \e[m]"
else
echo -e "[\e[1;31mFAILED\e[m]  172.16.1.$i"
#echo -e "172.16.1.$i [\e[1;31m FAILED \e[m]"
fi; 
done; 
VAR=`arp | grep "fc:aa:14:32:da:ce" | awk '{print $1}'`
if [[ ! -z $VAR ]]; then
echo -e "[\e[1;34mTARRGET\e[m] $VAR";
else
echo -e "[\e[1;34mTARRGET\e[m] \e[1;37mDOWN \e[m";
fi
