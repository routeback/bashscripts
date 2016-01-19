#!/bin/sh
#
# Name: bsw.sh
# Auth: Frank Cass
# Date: 20160119
# Desc: Quick blacksheepwall usage interactive script and parsing
#
###

echo "[*] Specify an input (e.g. targets.ip)"; read input
echo "[*] Name the output file"; read output
echo "[*] Provide a domain"; read domain
echo "[*] Provide your Bing API key"; read bing
echo "[*] Here we go..."
( set -x; for i in $(cat targets.ip); do blacksheepwall -fcrdns -bing $bing -reverse -robtex -srv -domain $domain -axfr -headers $i -json >> $output.bsw.json; done )
echo "[*] Done. Output saved as `pwd`/$output.bsw.json"
