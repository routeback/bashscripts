#!/bin/bash
#
# Name: nmap_report.sh
# Auth: Frank Cass
# Date: 20190525
# Desc: This script will check for XML files in the current directory and generate an nmap HTML report.
#
# Reference: https://nmap.org/book/output-formats-output-to-html.html
#
###

echo "[*] Nmap HTML Report Generator"

# Positional Parameter Development
#if [ "$1" != "" ]; then
#	case parameter in
#		--all)
#		--merge)
#		--alias)
#fi

if [ $(ls | grep .xml | wc -l) -eq "0" ]; then # Check if any XML files are in the directory
	echo "[!] No nmap XML files found in this directory!"
	echo "[*] Current directory: `pwd`"
	exit 1
	fi

if [ $(ls | grep .xml | wc -l) -eq "1" ]; then # If only one XML file is found, use it
        key=$(ls | grep .xml)
	echo "[*] Creating nmap HTML report of $key"
	fi

if [ $(ls | grep .xml | wc -l) -gt "1" ]; then # If multiple nmap XML outputs are found, let the user choose one to make a report from
	echo "[!] Multiple nmap XML outputs found! Pick one to generate a report."
	PS3="[*] Selection: "
	select FILENAME in *.xml;
	  do
	  case $FILENAME in
        	"$QUIT")
          		echo "[*] Exiting."
          		break
          		;;

        	*)
          		echo "[*] You picked $FILENAME ($REPLY)"
          		key="$FILENAME"
	  		break
          		;;
  	esac
  done
fi

filename=nmap_report.html
if [ -f $filename ]; then
        echo -n "[*] Output file 'nmap_report.html' exists. Overwrite? (y/n): "
        read response
        if printf "%s\n" "$response" | grep -Eq "$(locale yesexpr)"; then
                echo "[*] File overwrite enabled."
        else
                echo "[!] EXIT: Not overwriting existing file."
                exit 1
        fi
fi

xsltproc $key -o nmap_report.html

if [[ $? -ne 0 ]]; then
	echo "[!] EXIT: Something went wrong! Is this an nmap.xml file?"
	exit 1
else
	echo "[*] Report generated as nmap_report.html"
fi
