#!/bin/sh
#
# Name: scan.sh
# Auth: Frank Cass
# Date: 20160214
# Desc: Scan localhost NUM times then netcat to each open port that was found and output the results
#
###

target=localhost
scantimes=35536
portrange="30000-65535"

echo ""
echo "[*] Name: scan.sh"
echo "[*] Desc: Scan localhost with nmap multiple times then netcat to each open port"
echo "[*] Number of nmap scans $scantimes"
echo "[*] Port range $portrange"
echo "[*] Scanning in 5 seconds"; sleep 5
mkdir logs; touch logs/scan.xml; touch logs/scan.nmap; touch logs/scan.gnmap; touch logs/nc_connect.txt
for i in $(seq 1 $scantimes); do echo ""; echo "[*] Scan number: $i"; ( set -x; nmap -PN -p $portrange --open --reason -n -sT $target --append-output -oA logs/scan ); done
for i in $(cat logs/scan.nmap | grep -i open | grep -v "#" | sort -n | cut -d "/" -f 1); do nc -z -w 3 -v $target $i 2>&1 | tee -a logs/nc_connect.txt; done

