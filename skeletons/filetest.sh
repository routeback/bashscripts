#!/bin/bash

read -p "[*] Enter a filename to check for: " filename
# OR
filename=file.txt

if [ -f $filename ]; then
        echo -n "[*] Output file $filename exists. Overwrite? (y/n): "
        read response
	if printf "%s\n" "$response" | grep -Eq "$(locale yesexpr)"; then
		echo "[!] File overwrite enabled."
	else
		echo "[*] EXIT: Not overwriting existing file."
		exit 1
        fi
fi
