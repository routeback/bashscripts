#!/bin/bash
#
# Name: no_spaces.sh
# Auth: Frank Cass
# Date: 20160101
# Desc: This script will edit all folders and files from the current directory recusively, replacing any spaces with underlines
#
###

find . -depth -name '* *' | while IFS= read -r f ; do mv -i "$f" "$(dirname "$f")/$(basename "$f"|tr ' ' _)" ; done
