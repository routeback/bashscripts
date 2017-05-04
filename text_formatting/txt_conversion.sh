#!/bin/sh
#
# Name: txt_conversion.sh
# Auth: Frank Cass
# Date: 20151225
# Desc: TUI for quick conversion of .txt files
#
###

echo ""; echo "[*] -= txt_conversion.sh =-"; echo ""
echo "[*] Current working directory:" `pwd`; echo ""
echo "[*] txt_conversion Main Menu"; echo ""
echo "[*] Please select an option"
echo "----1) View a list of all .txt files within the current folder and all sub-folders"
echo "----2) Perform unix2dos conversion of all .txt files within the current folder and sub-folders"
echo "----3) Perform dos2unix conversion of all .txt files within the current folder and sub-folders"
read input
case $input in

	1)
		for i in $(find *.txt . | grep .txt); do echo $i; done
		;;
	2)
		for i in $(find *.txt . | grep .txt); do unix2dos $i; done
		;;
	3)
		for i in $(find *.txt . | grep .txt); do dos2unix $i; done
		;;
	*)
		echo "[*] Input not recognized. Exiting"; echo ""
		;;
esac
