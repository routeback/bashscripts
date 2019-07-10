#!/bin/bash
#
# Name: getdns.sh
# Auth: Frank Cass
# Date: 20190710
# Desc: Quickly retrieve DNS information from a list of hosts.
#
###

echo "[*] $0: Bulk DNS Information Retriever"

# Requirements
which dig &>/dev/null
if [[ $? -ne 0 ]]; then
        echo "[*] Try 'apt install -y dnsutils'"
        echo "[!] EXIT: dig needs to be installed to run this script!"
        exit 1
fi

filename=dns_info.txt
# Save the output to a file, allow the user to choose to overwrite or not
if [ -f $filename ]; then
        echo -n "[*] Output file $filename exists. Overwrite? (y/n): "
        read response
        if printf "%s\n" "$response" | grep -Eq "$(locale yesexpr)"; then
                echo "[*] File overwrite enabled."
        else
		echo "[*] Backup $filename or remove this check from the script to proceed."
                echo "[!] EXIT: Not overwriting existing file."
                exit 1
        fi
fi

# One parameter allowed, a line delimeted file
if [[ "$#" -gt 1 ]]; then
	echo "[!] EXIT: More than one parameter specified."
        exit 1
fi

if [ -f $1 ]
then
	: # Do nothing if the file actually exists.
else
	 echo "[!] EXIT: File does not exist. Please provide a line delimeted list of hostnames."
	 exit 1
fi

# Check if the provided parameter is empty or not
if [ "$1" != "" ]; then
	for i in $(cat $1); do
 	 echo "[*] DNS Records for: $i" | tee -a $filename; \
	 dig -t any +nocmd +noclass +nottlid $i | grep -v ";\|;;" | awk '{$1=$1}{ print }' | sed '/^\s*$/d' | tee -a $filename; \
	 echo "" | tee -a $filename; \
	done
else
	echo "[*] Please provide a line-delimited list of hostnames"
	echo "[*] Example usage: $0 /path/to/hosts.txt"
	exit 1
fi

# If the tool fails, alert to the user and exit
if [[ $? -ne 0 ]]; then
        echo "[!] EXIT: Something went wrong!"
        exit 1
else
	echo "[*] Report generated as $filename."
fi
