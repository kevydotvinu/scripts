#!/bin/bash
#
# NAME
#	CIS Benchmark - Remove security vulnerability in Ubuntu 16.04 LTS
#
# SYNOPSIS
#	bash cis-benchmark.sh
#
# DESCRIPTION
#	This script written for Ubuntu 16.04 LTS
#
# CHANGELOG
#	* Vinu K <kevy.vinu@gmail.com>
#	- Original code


function check-fs {
	#check loaded filesystem modules
	echo -e "#UNWANTED MODULES"
	for i in "${MODULES[@]}"
	do
		(lsmod | grep $i &> /dev/null)
		case $? in
			0) echo "$i module loaded"
				;;
			1) echo "$i module not loaded"
				;;
		esac
	done
	echo
}

function disable-fs {
	#disable unused filesystems
	for i in "${MODULES[@]}"
	do
		echo "install $i /bin/true" >> /etc/modprobe.d/CIS.conf
	done
}

function check-partition {
	#check seperate partitions
	echo "#PARTITOIN STATUS"
	echo -e "/tmp PARTITION STATUS"
	mount | grep '/tmp' || echo "No output"
	echo -e "/var PARTITION STATUS"
	mount | grep /var || echo "No output"
	echo -e "/var/tmp PARTITION STATUS"
	mount | grep /var/tmp || echo "No output"
	echo -e "/var PARTITION STATUS"
	mount | grep /var/tmp || echo "No output"
	echo -e "/var/log PARTITION STATUS"
	mount | grep /var/log || echo "No output"
	echo -e "/var/log/audit PARTITION STATUS"
	mount | grep /var/log/audit || echo "No output"
	echo -e "/home PARTITION STATUS"
	mount | grep /home || echo "No output"
	echo -e "/dev/shm PARTITION STATUS"
	mount | grep /dev/shm || echo "No output"
	echo
}

function check-stickybit {
	echo "#STICKY BIT ON DIRECTORIES"
	df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null || echo "No output"
	echo
}

function check-automount {
	echo "#AUTOMOUNTING"
	local OUTPUT=$(systemctl is-enabled autofs &>/dev/null)
	case $OUTPUT in
		enabled)
			echo ENABLED
			;;
		disabled)
			echo DISABLED
			;;
		*)
			echo "AUTOFS NOT INSTALLED"
			;;
	esac
	echo
}

function check-grubcfg {
	echo "#GRUB CONF PERMISSION"
	local OUTPUT=$(stat /boot/efi/EFI/fedora/grubx64.efi \
		| grep Uid | cut -d'(' -f2 | cut -d'/' -f1)
	echo "Current permission $OUTPUT"
	echo
}

function check-grubpasswd {
	echo "#GRUB PASSWORD"
	grep "^set superusers" /boot/efi/EFI/fedora/grubx64.efi
	echo
}

function check-rootpasswd {
	echo "#ROOT PASSWORD"
	grep '^root::' /etc/shadow &>/dev/null && echo "Not okay"
	grep '^root::' /etc/shadow &>/dev/null || echo "Okay"
	echo
}

function check-coredump {
	echo "#CORE DUMPS"
	grep "hard core" /etc/security/limits.conf /etc/security/limits.d/* \
		|| echo "Conf file not okay"
	grep "hard core" /etc/security/limits.conf /etc/security/limits.d/* \
		&& echo "Conf file okay"
	local OUTPUT=$(sysctl fs.suid_dumpable)
	case $OUTPUT in
		"fs.suid_dumpable = 0")
			echo "Kernel parameter okay"
			;;
		*)
			echo "Kernel parameter not okay"
			;;
	esac
	echo
}

function check-xdnx {
	echo "#XD/NX SUPPORT"
	local OUTPUT=$(dmesg | grep -w -e "NX" -e "active$" -e "protection")
	case $OUTPUT in
		*active*)
			echo "Okay"
			;;
		*)
			echo "Not okay"
			;;
	esac
	echo
}

MODULES=(cramfs freevxfs jffs2 hfs hfsplus squashfs vfat)
ROOT_UID=0
E_NOTROOT=87

if [[ -n "$1" ]]; then
	case $1 in
		check)
			
			if [[ "$UID" -eq "$ROOT_UID" ]]; then
				check-fs
				check-partition
				#check-stickybit
				check-automount
				check-grubcfg
				check-rootpasswd
				check-coredump
				check-xdnx
			else
				echo -e "Must be root to check OS vulnerability\nCheck will not affect present OS state"
				exit $E_NOTROOT
			fi
			;;
		deploy)
			disable-fs
			;;
		*)
			echo "USAGE: bash cis-benchmark check|diploy"
			;;
	esac
else
	echo "USAGE: bash cis-benchmark check|diploy"
fi
