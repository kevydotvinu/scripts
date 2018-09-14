#!/bin/bash

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
#sed "/${LINE}/c ${NEWLINE}" "/tmp/file" > "/tmp/data"
perl -i -p -e "s/$LINE/$NEWLINE/g" /tmp/file
fi
done < /tmp/file
}

set `date`
HH=`date +%H`
MM=`date +%M`
SS=`date +%S`
TIME=$HH-$MM-$SS

cp /tmp/file /tmp/file_$2$3$6_$TIME

OLDSERIAL=`cat /tmp/file | grep serial | awk '{print $1}'`
NEWSERIAL=`expr $OLDSERIAL + 1`

#echo "Your old serial is: $OLDSERIAL"
#echo ""
#echo "Your new serial is: $NEWSERIAL"
#echo ""
perl -i -p -e "s/$OLDSERIAL/$NEWSERIAL/g" /tmp/file


changeip "192.168.86.57" "192.168.86.5" "shakir-test"
changeip "192.168.86.00" "192.168.86.04" "nukul-test"
