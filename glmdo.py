#!/usr/bin/python

import os
import sys
import re
from os.path import expanduser

home = expanduser("~")
scripts = home + r"/Scripts"

def Usage():
    print ("Usage: glmdo <command>")
    print ("\t <command>: [freeip | toruser | awsvm]")
    print ""
    print ("Examples:")
    print ("\tglmdo [freeip]")
    print ("\t      The command is used to get free ip from current subnet")
    print ("\tglmdo [toruser]")
    print ("\t      The command is used to start tor user")
    print ("\tglmdo [awsvm]")
    print ("\t      The command is used to manage aws vm")
    return

def main():
    freeip = ("bash -c %s/freeip.sh" % scripts)
    toruser = ("bash -c %s/toruser.sh" % scripts)
    awsvm = ("bash -c %s/awsvm.sh" % scripts)

    if len(sys.argv) != 2:
        Usage()
        sys.exit(0)
    elif sys.argv[1] == "freeip":
        os.system(freeip)
        sys.exit(0)
    elif sys.argv[1] == "toruser":
        os.system(toruser)
        sys.exit(0)
    elif sys.argv[1] == "awsvm":
        os.system(awsvm)
        sys.exit(0)
    else:
        Usage()
        sys.exit(0)
main()
