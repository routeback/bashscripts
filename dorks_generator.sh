#!/bin/sh
#
# Name: dorks_generator.sh
# Auth: Frank Cass
# Date: 20151227
# Desc: Generate a list of Google Dork syntax search terms for a given domain
#
# 	TODO: Find a way to automatically open all links after they have been created
# 	TODO: Or discover the Google url structure to automatically generate a bunch of .html links to just open with for i in $(cat dorks.html.list); do chrome $i; done
#
###

echo ""; echo "		-= dorks_generator.sh =-"
echo "[*] Generate a list of Google Dork search terms for an organization"
echo "[*] Enter domain to use for Google Dorking, (example.com)"
read baseurl

echo "[*] Generating Dorks list"
cat << EOF >> $baseurl.dorks # Will prevent output of below echo's from being displayed; can then use column to print the output from the file
[-] Search for directory listing vulnerabilities: 	site:$baseurl intitle:index.of
[-] Search for configuration files: 			site:$baseurl ext:xml | ext:conf | ext:cnf | ext:reg | ext:inf | ext:rdp | ext:cfg | ext:txt | ext:ora | ext:ini
[-] Search for database files: 				site:$baseurl ext:sql | ext:dbf | ext:mdb
[-] Search for log files: 				site:$baseurl ext:log
[-] Search for backup and old files:			site:$baseurl ext:bkf | ext:bkp | ext:bak | ext:old | ext:backup
[-] Search for login pages: 				site:$baseurl inurl:login
[-] Search for publicly exposed documents: 		site:$baseurl ext:doc | ext:docx | ext:odt | ext:pdf | ext:rtf | ext:sxw | ext:psw | ext:ppt | ext:pptx | ext:pps | ext:csv
[-] Search for SQL errors: 				site:$baseurl intext:\"sql syntax near\" | intext:\"syntax error has occurred\" | intext:\"incorrect syntax near\" | intext:\"unexpected end of SQL command\" | intext:\"Warning: mysql_connect()\" | intext:\"Warning: mysql_query()\" | intext:\"Warning: pg_connect()\"
EOF
echo "[*] File saved as $baseurl.dorks"

