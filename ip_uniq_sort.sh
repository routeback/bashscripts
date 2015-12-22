#!/bin/sh
#
# Name: ip_uniq_sort.sh
# Auth: Frank Cass
# Date: 20151222
# Desc: Quickly sort a list of IP addresses by the 3rd and 4th octets, then remove any duplicates
#
#	Usage: cat targets.ip | ip_uniq_sort.sh
#
###

sort -t . -k 3,3n -k 4,4n | uniq
