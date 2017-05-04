#!/bin/sh
#
# Name: hosts.sh $1
# Auth: Frank Cass
# Date: 20151218
# Desc: Quickly ping scan a network
#
# 	Specify an IP range and it will ping scan for hosts, displaying those that
#	are online and offline.  If offline hosts are detected, it will output
#	them to a list to be checked with the hping_offline.sh script
#
###

# Run ifconfig and find available networks

ip=$(ifconfig | grep "inet addr:" | grep -v 127.0.0.1 | sed 's/inet addr://g' | cut -d ":" -f 1 | awk '{$1=$1}{ print }' | cut -d " " -f 1 | uniq)

# Split networks into individual variables

first3=$(echo $ip | sed 's/ /\n/g')
ip1=$(echo $first3 | cut -d " " -f 1)
ip2=$(echo $first3 | cut -d " " -f 2)
ip3=$(echo $first3 | cut -d " " -f 3)
ip4=$(echo $first3 | cut -d " " -f 4)

# Check if $1 was specified when calling $0
# If not, list the available networks

if [ -z "$1" ]; then
echo
echo "[*] Network Ping Scanner"
echo "[*] Usage: $0 <Network Range> "
echo "[*] Available Networks:"
echo "     " $ip1
echo "     " $ip2
echo "     " $ip3
exit 0
fi

### Ping Scanning Begin ###

echo
echo "[*] Ping scanning" $1

# Saving to file disabled, file removed at end of script
# echo "[*] Scans will be saved as hosts.scan in the current directory"

	nmap -sn -v $1 -oG hosts.scan > /dev/null 2>&1

# Pipe to /dev/null to suppress nmap output

	isup=$(cat hosts.scan | grep -v Down | grep -v "#")
	isdown=$(cat hosts.scan | grep -v Up | grep -v "#")

echo "[*] RESULTS:"; echo

echo Hosts Online:; echo
echo $isup | sed 's/ /\n/g' | grep -v Status | grep -v Host | grep -v "()" | grep -v Up # | cat > hostsonline.ip
echo
echo Hosts Offline:; echo
echo $isdown | sed 's/ /\n/g' | grep -v Status | grep -v Host | grep -v "()" | grep -v Down #  | cat > hostsoffline.ip
echo
rm hosts.scan
