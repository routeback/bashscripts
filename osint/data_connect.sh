#!/bin/sh
#
# Name: data_connect.sh
# Auth: Frank Cass
# Date: 20160101
# Desc: Parse a copy and paste of a data.com employee contacts page into an email list
#
#	TODO: Develop a separate tool for interacting with data.com API and gathering email addresses rather than cut/paste from free account (Limited to 200 max per page after switching from 50 in the drop-down
#
###

echo ""; echo "		-= data_connect.sh =-"; echo ""
echo "[*] Desc: This script will format a copy / paste of data.com contact names into an email list."
read -p "[*] Input a company email suffix (Eg. microsoft.com): " suffix
read -p "[*] Input the full path to the data_connect.txt file: " path
read -p "[*] Input a filename that you would like to output to: " filename
for i in $(cat $path  | awk '{$1=$1}{ print }' | sed 's/Direct Dial Available//g' | awk '{$1=$1}{ print }' | cut -d " " -f 1-2 | sed 's/, /./g' | sed 's/,//g'); do echo $i"@"$suffix >> $filename; done
echo "[*] Done. File saved to $filename"
