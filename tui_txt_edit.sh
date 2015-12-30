#!/bin/sh
#
# Name: tui_txt_edit.sh
# Auth: Frank Cass
# Date: 20151229
# Desc: TUI for quick text editing
#
# Usage: cat file.txt | tui_txt_edit.sh
#
###

# TODO: How to test if called from |
# TODO: How to test if called by ./ and targeting a file?
# 	IF $1 NOT EXIST, THEN PROMPT FOR FILE PATH
# TODO: When complete, if not called by | then ask if they would like to print out another file
# IF $1 Found, then don't do case statement for reading input, just jumpt to choices

echo "$# parameters"
echo "$@"

parameters () {
		if [ $# -lt 1 ]
		then
		echo ""; echo "Usage: $0 file.txt"
		exit
		fi
		}

main () {
echo ""; echo "[*] UNIX Tools Text Editor - Main Menu"; echo ""
echo "    Choose an option:"
echo "[1] Print only the first X characters of each line within a text file"
echo "[2] Print only the last X characters of each line within a text file"
echo "[3] Remove any extra (double or more) spaces and tabs from a text file"
echo "[4] Remove any new lines from a text file"
echo "[5] Remove all spaces from a text file"
echo "[6] Search for a specific string and print the line it was found in" # cat -n | grep $string
}

# input () {
# read input
# case $input in
# }

file () {
	case $1 in

	1)
		first_letter () {
		sed -r 's/^(.).*/\1/'
		}
		first_letter $1 # How to do the same but for stdin from |?
		;;
	2)
		;;
	3)
		remove_spaces_and_tabs () {
		awk '{$1=$1}{ print }'
		}
		remove_spaces_and_tabs $1
		;;

	4)
		;;
	5)
		;;
	6)
		;;
	7)
		;;
	8)
		;;
	9)
		;;
	[qQ])
		echo "[*] Exiting."; echo ""
		;;
	*)
		echo "[*] I don't understand."; echo ""
		;;
esac
echo "[*] Done"; echo ""
}

parameters $1
main $1
file $1
