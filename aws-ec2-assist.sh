#!/bin/bash
#
# NAME
# AWS ec2 assistance - Assist to do AWS ec2 tasks
#
# SYNOPSIS
# bash aws-ec2-assist.sh
#
# This script is written for make AWS ec2 tast easy
#
# CHANGELOG
# * Fri Dec 1 2017 Vinu K <kevy.vinu@gmail.com>
# - Original code

# declare ssh key path
KEY="/key.pem"

function launch {
	# Launches Ubuntu Server 16.04 LTS (HVM), SSD Volume Type instance
	echo
	aws ec2 run-instances \
		--count 1 --instance-type t2.micro \
		--key-name AWS_key_pair --security-groups default \
		--image-id ami-f3e5aa9c
}

function connect {
	# Connects to instances
	local COUNT=$(aws ec2 describe-instances \
		--filters "Name=instance-state-name,Values=running" \
		--output=json | grep PublicIpAddress | awk '{print $2}' | sed 's/"//g; s/,//g' | wc -l)
	local IP=$(aws ec2 describe-instances \
		--filters "Name=instance-state-name,Values=running" \
		--output=json | grep PublicIpAddress | awk '{print $2}' | sed 's/"//g; s/,//g' | xargs)
	echo
	if [[ COUNT != 1 ]]; then
		select CHOICE in $IP exit
		do
			if [[ $CHOICE != exit ]]; then
				ssh -i $KEY \
					ubuntu@$CHOICE
			elif [[ $CHOICE == exit ]]; then
				break
			fi
		done
	fi
}

function terminate {
	# Terminates instances
	echo
	aws ec2 terminate-instances \
		--instance-ids $(aws ec2 describe-instances \
		--filters "Name=instance-state-name,Values=running" \
		--output=json | grep -m1 InstanceId | awk '{print $2}' | sed 's/"//g; s/,//g')
}

function stop {
	# Stops instances
	echo
	aws ec2 stop-instances \
		--instance-ids $(aws ec2 describe-instances \
		--filters "Name=instance-state-name,Values=running" \
		--output=json | grep -m1 InstanceId | awk '{print $2}' | sed 's/"//g; s/,//g')
}

function start {
	# Starts instances
	echo
	aws ec2 start-instances \
		--instance-ids $(aws ec2 describe-instances \
		--filter "Name=instance-state-name,Values=stopped" \
		--output=json | grep -m1 InstanceId | awk '{print $2}' | sed 's/"//g; s/,//g')
}

function list {
	# Lists instances
	echo
	echo PublicIP
	aws ec2 describe-instances \
		--filters "Name=instance-state-name,Values=running" \
		--output=json | grep -m1 PublicIpAddress | awk '{print $2}' | sed 's/"//g; s/,//g'
}

# Runs script
PS3=$'\n'"AWS EC2 instances Asia Pacific (Mumbai)"$'\n'"Press 1 for first, ENTER for choice"$'\n'"#?) "
select choice in launch connect terminate list start stop exit
do
	if [[ $choice == launch ]]; then
		launch
	elif [[ $choice == connect ]]; then
		connect
	elif [[ $choice == terminate ]]; then
		terminate
	elif [[ $choice == list ]]; then
		list
	elif [[ $choice == start ]]; then
		start
	elif [[ $choice == stop ]]; then
		stop
	elif [[ $choice == exit ]]; then
		exit 0
	fi
done
