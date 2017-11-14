#!/bin/bash

function fetch {
while [ 0 ]; 
do wget -qO - http://www.commandlinefu.com/commands/random/plaintext | \
grep -v questions/comments | \
grep -v ScriptRock.com |  \
pv -q -L 9
sleep 1s
done
}

#export -f fetch
#xterm -e "fetch"
fetch
