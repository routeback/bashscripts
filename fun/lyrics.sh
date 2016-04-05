#!/bin/bash
#
# Name: lyrics.sh
# Auth: Frank Cass
# Date: 20160428
# Desc: Query for a songs lyrics and display them to the user.
#       Works best when input is <Band> <Song Name>
#
###

# Banner

function ascii_art () {
echo ""
echo "|___|)___________________________________________________________"
echo "|___/____________________________________________________________"
echo "|__/|____________________________________________________________"
echo "|_/(|,\___Lyrics.sh______________________________________________"
echo "|_\_|_/__________________________________________________________"
echo "|   | "
echo "| (_|   Enter <Band> <Song Name> to begin"
echo
}

# Read User Input & format the search query for the website

function query () {
read -p "[*] Search: " search

# Replace spaces with + for URL encoding

search_string=$(echo $search | sed 's/ /+/g')
baseurl=http://search.plyrics.com/search.php?q=

# Build the search string

edited_url=$(echo $baseurl | sed "s/=/=$search_string=/g")
}

function urlquery () {

# Perform the search for lyrics with the search query

curl -s -o /tmp/lyric_curl.html $edited_url

first_result=$(cat /tmp/lyric_curl.html | grep -A 1 "<td><b>1" | grep -i "<a href=" | cut -d '"' -f 2)

# Make the curl request to the lyric website for the search results and save to a file

curl -s -o /tmp/lyrics.html -A "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5" $first_result

# Formatting text output

echo "[*] Found Song Lyrics!"; echo
cat /tmp/lyrics.html | sed -n '/start of lyrics/,/end of lyrics\|^$\|pattern/p' | grep -B 100 "end of lyrics" | grep -v "start of lyrics" | grep -v "end of lyrics" | sed 's#<br />##g' | grep -v "<i>"; echo
echo "[*] End Song Lyrics"; echo

# Remove temporary saved files

rm /tmp/lyric_curl.html > /dev/null 2>&1; rm /tmp/lyrics.html > /dev/null 2>&1
}

# Call all of the functions

ascii_art
query
urlquery
