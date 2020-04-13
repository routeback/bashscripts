#!/bin/bash

function snaps() {
	echo "[*] Starting snapd service..."
	service snapd start 2>&1 /dev/null
	echo "[*] Installed Snaps:"
	snap list; echo ""
}

mkdir sysinfo 2>&1 /dev/null
snaps | tee -a sysinfo/snaps.txt

echo "[*] Info Gathering Complete!"
echo "[*] Logs stored in sysinfo/*.txt"
