#!/bin/sh
#
# Name: deepsearch.sh
# Auth: Frank Cass
# Date: 20160412
# Desc: Specify a string and it will search the directory recursively for it
#
###

if [ -z "$1" ]; then
echo "[*] Search a directory recursively"
echo "[*] Usage: $0 <String>"
exit 0
fi

ls * -R | grep -i $1

