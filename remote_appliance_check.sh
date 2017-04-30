#!/bin/sh
#
# Name: remote_appliance_check.sh
# Auth: Frank Cass
# Date: 20170429
# Desc: Ping checking utility to determine when a remote testing appliance goes from being offline to online.
#
###

read -p "[*] Enter an IP address: " ip
	while true
	do
	echo ""; ping -W 5 -c 1 -q $ip

if [ $? -eq 0 ]
	then
	echo ""; echo "[*] APPLIANCE ONLINE as of `date`"; echo ""; exit 0
else
	echo "=================================================="
	echo "[*] APPLIANCE OFFLINE as of `date`"; echo "[*] Sleeping 5 seconds and retrying..."
	echo "=================================================="; sleep 5
fi
done
