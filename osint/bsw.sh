#!/bin/bash
#
# Name: bsw.sh
# Auth: Frank Cass
# Date: 20181105
# Desc: Wrapper for blacksheepwall (https://github.com/tomsteele/blacksheepwall)
# 	Bing commands disabled by default. Uncomment and move parameters to re-include this feature.
###

alias | grep blacksheepwall &>/dev/null
if [ $? -ne 0 ]; then
	echo "[!] Blacksheepwall needs to be aliased to 'blacksheepwall'"
	echo "[*] If using a compiled ELF binary, try using this script: ";
	echo ""; cat << 'EOF';
alias blacksheepwall=$(cd /root/scripts/blacksheepwall; for i in $(find . -exec file {} \; | grep -i elf | cut -d ":" -f 1 | cut -d "." -f 2 | head -n 1); do echo `pwd`$i; done) 
EOF
	echo ""; echo "[*] Then source this script (eg. source bsw.sh)"
	exit 1
fi

echo "[*] Blacksheepwall Wrapper - Quicky perform hostname recon."
echo "[*] =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
read -p "[*] Specify the path to a list of hosts: " input1
read -p "[*] Provide the domain name for your search: " domain
# read -p "[*] Provide your Bing API key [Optional]: " bing

~/scripts/blacksheepwall/blacksheepwall_linux_amd64 \
-input $input1 \
-fcrdns \
-srv \
-domain $domain \
-axfr \
-headers \
-tls \
-csv

# -bing $bing \
# -reverse \
