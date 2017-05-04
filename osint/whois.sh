#!/bin/sh
#
# Name: whois.sh
# Auth: Frank Cass
# Date: 20151225
# Desc: Quick WHOIS lookup script
#
###

echo "[*] Enter organization name"
read name
echo "[*] Enter path to targets.ip"
read targets
echo "[*] Beginning WHOIS Lookup"; echo ""
for i in $(cat "$targets"); do echo "WHOIS Lookup for: $i"; whois -H $i | grep $name; done
echo "[*] Done"; echo ""
