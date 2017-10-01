#!/bin/sh
#
# Name: portcheck.sh
# Auth: Frank Cass
# Date: 20171001
# Desc: Checks which TCP ports are filtered or allowed by your network.
#
###

if [ -z "$1" ]; then
echo "[*] Outbound Port Checker"
echo "[*] Usage: $0 <port number> "
exit 0
fi

curl http://portquiz.net:$1
