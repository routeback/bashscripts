#!/bin/bash
#
# Name: pingwatch.sh
# Auth: Frank Cass
# Date: 20160328
# Desc: Run tcpdump listening for ICMP traffic
#
###

read -p "[*] Enter an interface name: " interface

tcpdump -i $interface ip proto \\icmp
