#!/bin/sh
#
# Name: myip.sh
# Auth: Frank Cass
# Date: 20160509
# Desc: Quickly print the IP of a linux host using ifconfig
#
###

ifconfig | grep "inet addr:" | grep -v 127.0.0.1 | sed 's/inet addr://g' | cut -d ":" -f 1 | awk '{$1=$1}{ print }' | cut -d " " -f 1 | uniq
