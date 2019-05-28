#!/bin/bash
#
# Name: nmap_report.sh
# Auth: Frank Cass
# Date: 20190525
# Desc: This script will check for XML files in the current directory and generate an nmap HTML report.
# 	Additionally, this script can be used to merge multiple scans or generate multiple reports.
#
# Reference: https://nmap.org/book/output-formats-output-to-html.html
#
# TODO: Expand capability to detect what type of XML file is being parsed and support additional tool exports.
#
###

echo "[*] Nmap HTML Report Generator"

usage (){
				echo "[*] Description: Quickly generate an nmap HTML report."
				echo "[*] OPTIONAL Parameters:"
				echo "		--all"
				echo "			Generate a report for each .XML file in the current directory"
				echo "		--merge"
				echo "			For all nmap.xml files, merge them into a comprehensive .XML file and generate a single report"
				echo "		--alias"
				echo "			Add the alias 'nreport' to your ~/.bashrc "
				echo "		-h (--help)"
				echo "			 This help menu"
}

if [[ "$#" -gt 1 ]]; then
	usage
	echo ""; echo "[*] EXIT: One parameter at a time, please!"
	exit 1
fi

while [ "$1" != "" ]; do
    case $1 in
        --all )	# For every .xml in the current directory, run the report generator against it
				echo "[*] Generating a report for each XML in the current directory."
				# Implement loop function here
				exit 0 # Remove this when loop implemented
                                ;;
        --merge )	# For all nmap.xml files, merge them into a single .XML and jump straight to the report generation function
				echo "[*] Merging all XML files into a single report."
				# Implement merge function here
				exit 0 # Remove this when merge implemented
                                ;;
        --alias )	# Add the alias 'nreport' to your ~/.bashrc file
				echo "[*] Adding alias 'nreport' to your ~/.bashrc."
				echo "alias nreport='`pwd`/$0'" >> ~/.bashrc
				exit 0
				;;
	-h | --help )	# This help menu of usage instructions
				usage
				exit 0
				;;
        * )                     usage
				echo ""; echo "[*] EXIT: Invalid parameter supplied."
                                exit 1
    esac
done

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
