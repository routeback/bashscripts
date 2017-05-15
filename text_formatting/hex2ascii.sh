#!/bin/bash
#
# Name: hex2ascii.sh
# Auth: Frank Cass
# Date: 20170514
# Desc: Quickly convert hexadecimal code in the format of "\x00" into readable ascii*
#
###

if [ -z "$1" ]; then
echo "[*] Hex to ASCII converter"
echo "[*] Usage: $0 <Delimited hexcode \x contained in quotes>"
echo "[*] Example: $0 \"\x74\x65\x73\x74\x0A\""
exit 0
fi

echo -en  $1 | awk '{printf "%s\n", $_}'

