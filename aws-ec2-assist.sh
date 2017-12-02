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

function launch {
	echo
	aws ec2 run-instances \
		--count 1 --instance-type t2.micro \
		--key-name AWS_key_pair --security-groups default \
		--image-id ami-f3e5aa9c
	echo
}

function connect {
	echo
	COUNT=$(aws ec2 describe-instances \
		--filters "Name=instance-state-name,Values=running" \
		--output=table | grep PublicIpAdd | awk '{print $4}' | wc -l)
	VALUES=$(aws ec2 describe-instances \
		--filters "Name=instance-state-name,Values=running" \
		--output=table | grep PublicIpAdd | awk '{print $4}' | xargs)
	if [[ COUNT != 1 ]]; then
		select CHOICE in $VALUES exit
		do
			if [[ $CHOICE != exit ]]; then
				ssh -i ~/Downloads/AWS_key_pair.pem \
					ubuntu@$CHOICE
			elif [[ $CHOICE == exit ]]; then
				break
			fi

		done
	fi
	echo
}

function terminate {
	echo
	aws ec2 terminate-instances \
		--instance-ids $(aws ec2 describe-instances \
		--filters "Name=instance-state-name,Values=running" \
		--output=table | grep -m1 InstanceId | awk '{print $4}')
	echo
}

function list {
	echo
	echo PublicIP
	aws ec2 describe-instances \
		--filters "Name=instance-state-name,Values=running" \
		--output=table | grep PublicIpAddress | awk '{print $4}'
	echo
}

PS3=$'\n'"AWS EC2 instances Asia Pacific (Mumbai)"$'\n'"Press 1 for first, ENTER for choice"$'\n'"#?) "
select choice in launch connect terminate list exit
do
	if [[ $choice == launch ]]; then
		launch
	elif [[ $choice == connect ]]; then
		connect
	elif [[ $choice == terminate ]]; then
		terminate
	elif [[ $choice == list ]]; then
		list
	elif [[ $choice == exit ]]; then
		exit 0
	fi
done
