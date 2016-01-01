#!/bin/sh
#
# Name: data_connect.sh
# Auth: Frank Cass
# Date: 20160101
# Desc: Parse data.com paste of employee information and parse it into an email list
#
#	TODO: Develop separate tool for interacting with API rather than cut/paste from free account (Limited to 200 max per page after switching from 50 in the drop-down
#
###

echo ""; echo "		-= data_connect.sh =-"
echo "[*] Enter a company email suffix (Eg. microsoft.com"
read suffix
echo "[*] Input the full path to the data_connect.txt dump"
read path
echo "[*] Enter a filename to save the output to"
read filename # If filename has spaces in it's path, it wont work
echo "[*] Parsing..."
for i in $(cat $path  | awk '{$1=$1}{ print }' | sed 's/Direct Dial Available//g' | awk '{$1=$1}{ print }' | cut -d " " -f 1-2 | sed 's/, /./g' | sed 's/,//g'); do echo $i"@"$suffix >> $filename; done
echo "[*] Done"
