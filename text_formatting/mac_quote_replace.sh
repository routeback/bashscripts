#!/bin/sh
#
# Name: mac_quote_replace.sh
# Auth: Frank Cass
# Date: 20160103
# Desc: Replace quotes from OSX with normal linux ascii (unicode?) quotes
# 	Ex. When copying a script from OSX and pasting it into linux terminal
#	Usage: cat file.txt | mac_quote_replace.sh
#
###

sed 's/“/"/g' | sed 's/”/"/g'
