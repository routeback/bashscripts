#!/bin/sh -i
#
# Name: append.sh
# Auth: Frank Cass
# Date: 20151213
# Desc: Uses `history` to retrieve the last command (ignoring execution of $0) and then appends it to the command log with a timestamp.
# 
# Usage:       source append.sh
# Alt Usage:   alias append="source /PATH/TO/append.sh"
# Example:     
#		$ echo "This is something important I want logged to remember later"
#		$ append
#		  	[*] Retrieving last command: echo "This is something important I want logged to remember later"
# 		  	[*] Command appended to command.log: /Users/Frank/Desktop/command.log
#		$ cat command.log
#		  	Mon Dec 14 10:55:10 PST 2015: echo "This is something important I want logged to remember later"
#
# NOTE:        Must be sourced (Ex. $ source append.sh) to run properly, otherwise `history` will have nothing to report. See http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x237.html
#
# Created and tested on OSX 10.11.1 (15B42) using iTerm2
#
###

function last_command {
history | tail -n 2 | head -n 1 | cut -d ' ' -f 4-80
}

echo -n "[*] Retrieving last command: "; last_command
echo `date`: `last_command` >> command.log
echo "[*] Command appended to command.log: `pwd`/command.log"
