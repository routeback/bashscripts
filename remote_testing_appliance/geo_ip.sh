#!/bin/bash
#
# Name: geo_ip.sh
# Auth: Frank Cass
# Date: 20180212
# Desc: This script will check https://www.geoiptool.com/ to identify your location.
#
###

# Request the webpage and output to a file
curl -L https://www.geoiptool.com/ -o /tmp/geoip_lookup.txt -s

# Parse the file into a readable format
cat /tmp/geoip_lookup.txt | grep -A 10 '<div class="data-item">' | grep -A 1 'City\|Country' | awk '{$1=$1}{ print }' | sort -n | uniq | tail -n 2 | sed 's/<span>//g' | sed 's/<\/span>//g' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/, /g' > /tmp/geoip_location.txt

# Display the parsed output with some wrapper text
echo "[*] Your current location is: `cat /tmp/geoip_location.txt`"


