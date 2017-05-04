#!/bin/sh
#
# Name: web_headers.sh
# Auth: Frank Cass
# Date: 20160412
# Desc: Curls all web headers in a txt file
#
###

if [ -z "$1" ]; then
echo "[*] Please specify a line delimeted file of IP:PORT"
echo "[*] Note: If port is not specified, port 80 will be used"
echo "[*] Usage : $0 <path/to/web.ip>"
exit 0
fi

for i in $(cat $1)
do echo "Connecting to $i" >> web_headers.txt
curl -k -L -s -I $i -m 5 >> web_headers.txt
done

