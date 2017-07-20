#!/bin/sh
#
# Name: append.sh
# Auth: Frank Cass
# Date: 20151213
# Desc: Appends the last command in the terminal to a log file with a timestamp.
#
# Usage:       source append.sh
# Alt Usage:   alias append="source /PATH/TO/append.sh"
#
# Example:
#		$ echo "Example"
#		$ append
#		  	[*] Retrieving last command: echo "Example"
# 		  	[*] Command appended to command.log: /Users/Frank/Desktop/command.log
#		$ cat command.log
#		  	Mon Dec 14 10:55:10 PST 2015: echo "Example"
#
# Details:	Must be sourced (Ex. $ source append.sh) to run properly, otherwise `history` will have nothing to report.
#		See http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x237.html
#
###

if [ $0 != bash ]; then

	echo "[*] Exiting. Script must be sourced."
	echo "[*] Try: source append.sh"
	return 1
fi

function last_command {

	history | tail -n 2 | head -n 1 | cut -d ' ' -f 4-80
}

echo -n "[*] Retrieving last command: "; last_command
echo `date`: `last_command` >> command.log
echo "[*] Command appended to command.log: `pwd`/command.log"
