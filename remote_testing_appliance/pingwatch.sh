#!/bin/bash
#
# Name: pingwatch.sh
# Auth: Frank Cass
# Date: 20160328
# Desc: Run tcpdump listening for ICMP traffic
#
###

tcpdump ip proto \\icmp
