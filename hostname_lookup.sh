#!/bin/sh
#
# Name: hostname_lookup.sh
# Auth: Frank Cass
# Date: 20160218
# Desc: Resolve all worksheet IPs in a table to populate the hostname table.
#
###

if [ -z "$1" ]; then
echo "[*] Simple hostname lookup script"
echo "[*] Usage : $0 <Path to targets.ip "
exit 0
fi
echo "hostname_lookup.sh"
echo "[*] Desc: Takes a line delimeted file of IPs and performs a hostname lookup for each one."
echo ""; for i in $(cat $1); do echo [*] Hostname Lookup for $i; host $i | head -n 1 | tee -a hostname.lookup; echo ""; done
echo "[*] Formatting..."; ( set -x; cat hostname.lookup | grep -v "*" | cut -d " " -f 5 | sed 's/3(NXDOMAIN)/NA/g' > hostname.only ); echo ""
echo "[*] Raw output saved to: hostname.lookup"
echo "[*] Hostname formatted output saved to: hostname.only"; echo ""
echo "[*] Original targets list contained: $(cat $1 | wc -l) lines."
echo "[*] Formatted output contains: $(cat hostname.only | wc -l) lines."; echo ""
