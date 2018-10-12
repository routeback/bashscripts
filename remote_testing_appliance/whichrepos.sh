#!/bin/bash
#
# Name: whichrepos.sh
# Auth: Frank Cass
# Date: 20181011
# Desc: Quickly identify which repositories you have cloned.
#	Works best if all of your tools are stored in a single directory.
#
###

clear

echo "[*] Here are a list of git repo's you have cloned in $PWD: "

for i in $(ls -lrt -d -1 $PWD/* | grep "^d" | awk '{$1=$1}{ print }' | cut -d " " -f 9)
do
	cd $i
	git config --get remote.origin.url
	cd ../;
done
