#!/bin/bash
#
# Copyright 2017 kevydotvinu.github.com
#
# NAME
#     post-installation-script - configure laptop as WiFi access point
# SYNOPSIS
#     post-installation-script SSID PSK
#
#     This script is written for Ubuntu 16.04 LTS
#
# DESCRIPTION
#     This script is the configuration script to build WiFi access point and intend to be run once
#
# CHANGELOG
#   * Tue Aug 29 2017 Vinu K <kevy.vinu@gmail.com>
#   - original code

#Initialize and set some variables
SSID=$1
PSK=$2

function network {
	# static ip assign for enp5s0 and wlp6s0
	cat << EOF | tee -a /etc/network/interfaces
	#<PIS
	auto enp5s0
	iface enp5s0 inet static
		address 192.168.1.1
		netmask 255.255.255.0

	auto wlp6s0
	allow-hotplug wlp6s0
	iface wlp6s0 inet static
		address 192.168.2.1
		netmask 255.255.255.0
	#PIS>
EOF
}

function dnsmasq {
	#assigning dhcp ip range
	cat << EOF | tee -a /etc/dnsmasq.d/01-pihole.conf
	#<PIS
	dhcp-range=192.168.2.2,192.168.2.10,12h
	#PIS>
EOF
}

function hostapd {
	#hostapd installation and configuration file
	sh -c "apt install -y hostapd"
	cat << EOF | tee /etc/hostapd/hostapd.conf
	#<PIS
	ssid=SSID
	wpa_passphrase=PSK
	interface=wlp6s0
	#bridge=br0
	auth_algs=3
	channel=7
	driver=nl80211
	hw_mode=g
	logger_stdout=-1
	logger_stdout_level=2
	max_num_sta=5
	rsn_pairwise=CCMP
	wpa=2
	wpa_key_mgmt=WPA-PSK
	#wpa_pairwise=TKIP CCMP
	#PIS>
EOF

	cat << EOF | tee -a /etc/default/hostapd
	#<PIS
	DAEMON_CONF="/etc/hostapd/hostapd.conf"
	#PIS>
EOF

}

function iptables {
	#iptable configuration for nat and forwarding
	iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
	iptables -t nat -A POSTROUTING -o enp5s0 -j MASQUERADE
	iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
	iptables -A FORWARD -i wlp6s0 -o ppp0 -j ACCEPT
	iptables -A FORWARD -i wlp6s0 -o enp5s0 -j ACCEPT
	iptables -A FORWARD -i vboxnet0 -o ppp0 -j ACCEPT
	iptables -A FORWARD -i vboxnet0 -o enp5s0 -j ACCEPT
	iptables -A INPUT -p tcp --dport 80 -s 127.0.0.1 -j ACCEPT
	iptables -A INPUT -p tcp --destination-port 80 -j DROP

	sh -c "iptables-save > /etc/iptables-ipv4-nat"
	echo "iptables-restore < /etc/iptables-ipv4-nat" | tee /lib/dhcpcd/dhcpcd-hooks/70-ipv4-nat

	cat << EOF | tee /lib/dhcpd/dhcpcd-hooks/70-ipv4-nat
	#<PIS
	iptables-restore < /etc/iptables-ipv4-nat
	#PIS>
EOF
}

function dhcpcd {
	#dhcpcd settings to ignore wlp6s0 interface
	cat << EOF | tee -a /etc/dhcpcd.conf
	#<PIS
	denyinterfaces wlp6s0
	#PIS>
EOF
}

function port_forward {
	#port forwarding
	sed -i.bak -e 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
}

# configure script
type pihole &>/dev/null
if [ $? == 0 ] && [ $# == 2 ]; then
port_forward
echo "Success"
else
echo "Error running script"
echo "Install pihole first or Usage: post-installation-script.sh SSID PSK"
fi
