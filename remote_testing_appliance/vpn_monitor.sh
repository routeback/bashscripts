#!/bin/bash
#
# Name: vpn_monitor.sh
# Auth: Frank Cass
# Date: 20190525
# Desc: Monitor the status of the openvpn process to determine if a vpn connection is established or not.
#	Combine with Conky for a visual desktop widget.
#
###

sleep_seconds=1
RED='\033[0;31m'
GREEN='\033[0;32m'
rm /tmp/vpnstate 2&>1 /dev/null
touch /tmp/vpnstate

function vpn_check() {

sleep $sleep_seconds

if pidof openvpn 2>&1 /dev/null is true
	then
		echo -e "${GREEN}[*] OpenVPN is active." | tee /tmp/vpnstate
		vpn_check
	else
		echo -e "${RED}[!] VPN is not connected." | tee /tmp/vpnstate
		vpn_check
fi

}

vpn_check
