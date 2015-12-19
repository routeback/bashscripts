#!/bin/bash
#
# Name: clickjack_poc_gen.sh
# Auth: Frank Cass
# Date: 20151218
# Desc: Generate Clickjacking PoC HTML from URL and place it in /var/www
#
###

echo "[*] -= clickjack_poc_gen.sh =-"
# echo "This script will create a .html file of the supplied URL within an iFrame to test for clickjacking"
echo "[*] Desc: Quickly create a clickjacking test page and copy it to /var/www"
echo "[*] Please enter a URL, such as http://example.com"; read url
echo "[*] What shall we call the filename? (Will be suffixed automatically with .html)"
read filename
echo "[*] Please set height and width percentage (1-100)"
read num
touch $filename.html
cat > $filename.html <<EOF
<html>
   <head>
     <title>Clickjack test page</title>
   </head>
   <body>
     <p>Website is vulnerable to clickjacking!</p>
     <iframe src="$url" style="border: 0; width: $num%; height: $num%"></iframe src>
   </body>
</html>
EOF
echo "[!] Clickjacking PoC saved in your current direcotry as:" $filename.html
cp $filename.html /var/www/$filename.html
echo "[*] Also copied to /var/www/"
echo "[*] Start your local webserver and try to browse to localhost/"$filename
