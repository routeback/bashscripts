#!/bin/bash
#
# Name: updaterepos.sh
# Auth: Frank Cass
# Date: 20181011
# Desc: Quickly update repositories you have cloned.
#	Works best if all of your tools are stored in a single directory.
#
###

clear

echo "[*] Updating repositories stored in $PWD"
echo "[*] Starting in 3...2...1..."; sleep 3

for i in $(ls -lrt -d -1 $PWD/* | grep "^d" | awk '{$1=$1}{ print }' | cut -d " " -f 9)
do
	cd $i
	echo "[*] Updating $i."
	git -q pull 2> /dev/null
	cd ../
done

echo "[*] Done."
