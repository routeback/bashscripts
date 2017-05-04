#!/bin/bash
#
# Name: snmp_scan.sh
# Auth: Frank Cass
# Date: 20160101
# Desc: Quickly scan hosts for SNMP and then perform snmpcheck
#
###

echo "[*] Enter IP Address or Range"
read ip
nmap -sU -p 161 -n $ip --open -oG snmp.gnmap
cat snmp.gnmap | grep -i open | grep -v "#" | cut -d  "(" -f 1 | cut -d ":" -f 2 | awk '{$1=$1}{ print }' > snmp.txt
for i in $(cat snmp.txt); do snmpcheck -t $i | tee -a snmp.check; done
echo ""; echo "[*] Files Saved: snmp.gnmap, snmp.txt, snmp.check"
echo "[*] Done"
