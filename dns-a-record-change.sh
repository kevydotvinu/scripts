#!/bin/bash
#
# NAME
# DNS A-record entry change - Replace DNS zone file IP
#
# SYNOPSIS
# bash dns-a-record-change.sh
#
# This script is written for replace the IP address of DNS zone file
#
# CHANGELOG
# * Fri Sep 15 2018 Vinu K <kevy.vinu@gmail.com>
# - Original code

function changeip {
OLDIP="$1"
NEWIP="$2"
HOSTNAME="$3"

while read line
do
HOST=`awk '{print $1}' <<< "$line"`
IP=`awk '{print $4}' <<< "$line"`
if [[ "$IP" == "$OLDIP" ]] && [[ "$HOST" == "$HOSTNAME" ]]; then
echo "MATCHED LINE: $line"
LINE="$line"
NEWLINE=`sed "s/${OLDIP}/${NEWIP}/g" <<< "${LINE}"`
echo "CHANGED LINE: $NEWLINE"
perl -i -p -e "s/$LINE/$NEWLINE/g" "$PATH"
fi
done < "$PATH"
}

# Declare variable
PATH="/tmp/file"

# changeip "OLD_IP" "NEW_IP" "HOSTNAME"
changeip "192.168.86.57" "192.168.86.5" "shakir-test"
changeip "192.168.86.00" "192.168.86.04" "nukul-test"
