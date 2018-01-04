#!/bin/bash
#
# Name: vpn_monitor.sh
# Auth: Frank Cass
# Date: 20170101
# Desc: Monitor the status of the openvpn process to determine if a vpn connection is established or not.
#	Combine with Conky for a visual desktop widget.
#
###

sleep_seconds=1
RED='\033[0;31m'
GREEN='\033[0;32m'

vpn_check() {

if pidof openvpn > /dev/null is true
	then
		echo -e "${GREEN}[*] OpenVPN is active." | tee vpnstate
		sleep $sleep_seconds
		vpn_check
	else
		echo -e "${RED}[!] VPN is not connected." | tee vpnstate
		sleep $sleep_seconds
		vpn_check
	fi
}

rm vpnstate 2>&1 > /dev/null
touch vpnstate
vpn_check
