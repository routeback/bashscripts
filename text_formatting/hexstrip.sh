#!/bin/bash
#
# Name: hexstrip.sh
# Auth: Frank Cass
# Date: 20170514
# Desc: Quickly strip hexcode in the format of "\x00" into a single bytestream"
#
###

if [ -z "$1" ]; then
echo "[*] Hex to single bytestream converter"
echo "[*] Usage: $0 <Delimited hexcode \x contained in quotes>"
echo "[*] Example: $0 \"\x74\x65\x73\x74\x0A\""
echo "[*] Output: 746573740A"
exit 0
fi

echo $1 | sed 's/"//g' | sed 's/,//g' | sed 's/x//g' | sed 's/\\//g'

