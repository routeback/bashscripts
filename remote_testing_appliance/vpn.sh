#!/bin/sh
#
# Name: vpn.sh
# Auth: Frank Cass
# Date: 20160505
# Desc: Quick VPN Tunnel setup
#
###

echo ""
echo "	~VPN Tunnel~"
echo "[*] Choose one of the following:"
echo "---[1] Normal VPN Connection"
echo "---[2] Full VPN Tunnel"
echo ""
cd ~/path/to/vpn/
read -p "[*] Selection: " choice; echo ""
case $choice in
	[1])
		openvpn --config ~/path/to/vpn/vpn.conf
		;;
	[2])
		openvpn --config ~/path/to/vpn/vpn.conf --redirect-gateway
		;;
	*)
		echo "[*] Invalid"
		;;
esac
