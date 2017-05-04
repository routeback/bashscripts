#!/bin/sh
#
# Name: iploop.sh
# Auth: Frank Cass
# Date: 20151218
# Desc: Quick Whois using ipinfo.io API which returns JSON
#
###

echo "[*] Enter an IP"
read ip
curl ipinfo.io/$ip; echo
echo "[*] Query Done"
