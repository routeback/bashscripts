#!/bin/sh
#
# Name: trafficmon.sh
# Auth: Frank Cass
# Date: 20160101
# Desc: Sets up iptables for a single ip to monitor traffic usage
#
# 	TODO: Implement bytes to KB/MB/GB/ comparison - Also print out to chart like ifconfigs
# 	TODO: Packet to byte ratio for size, ex. 100 packets = XX% of data transmitted
#
###

if [ -z "$1" ]; then
echo "[*] Please specify a single ip address to monitor inbound/outbound traffic"
echo "[*] Usage : $0 <ip address> "
exit 0
fi

echo [*] Configuring iptables for $1
iptables -I INPUT 1 -s $1 -j ACCEPT
iptables -I OUTPUT 1 -d $1 -j ACCEPT

read -p "[*] Would you like to reset the traffic count? [y/n]" yn
case $yn in
        [Yy]* ) iptables -Z; echo "[*] iptables have been reset!"; break;;
        [Nn]* ) ;;
        * ) echo "[*] I do not understand. Exiting"; exit 0;;
esac

while true; do
	read -p "[*] Would you like to view the current traffic? [y/n]" yn
	case $yn in
		[Yy]* ) iptables -vn -L; break;;
		[Nn]* ) echo "[*] Script Complete"; exit;;
	        * ) echo "[*] I do not understand. Exiting"; exit 0;;
	esac
done
