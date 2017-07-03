#!/bin/bash
#
# Name: ip_regex.sh
# Auth: Frank Cass
# Date: 20170703
# Desc: Identify IP addresses within a string or file
#
# Usage: cat text | ip_regex.sh
#
###

grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
