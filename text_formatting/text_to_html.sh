#!/bin/sh
#
# Name: text_to_html.sh
# Auth: Frank Cass
# Date: 20181016
# Desc: Convert a plain text letter into an HTML formatted email. Be sure to edit the variables to match your filenames.
#
# Usage: ./text_to_html.sh
#
###

INPUT=email.txt
OUTPUT=email.html

echo "<html>" >> $OUTPUT
echo "<body>" >> $OUTPUT

while read line
do
	echo "<p>$line</p>" >> $OUTPUT
done < $INPUT

echo "</body>" >> $OUTPUT
echo "</html>" >> $OUTPUT
