#!/bin/sh
#
# Name: awk_spaces.sh
# Auth: Frank Cass
# Date: 20151227
# Desc: Quickly remove extra spaces from std in. Alias for convenient usage
#
# Usage: cat text | awk_spaces.sh
#
###

awk '{$1=$1}{ print }'
