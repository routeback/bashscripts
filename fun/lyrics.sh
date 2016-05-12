#!/bin/bash
#
# Name: lyrics.sh
# Auth: Frank Cass
# Date: 20160511
# Desc: Query for a songs lyrics and display them to the user.
#       Works best when input is <Band> <Song Name>
#
###

# Flush temporary saved files

rm /tmp/lyric_curl.html > /dev/null 2>&1; rm /tmp/lyrics.html > /dev/null 2>&1

# Banner

function ascii_art () {
echo ""
echo " \"Music can change the world, because it can change people.\" Bono"
echo ""
echo " ___|)___________________________________________________________"
echo "|___/____________________________________________________________"
echo "|__/|____________________________________________________________"
echo "|_/(|,\___Lyrics.sh______________________________________________"
echo "|_\_|_/__________________________________________________________"
echo "    | "
echo "  (_|   Enter <Band> <Song Name> to begin"
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

# Perform the search for lyrics with the search query

function urlquery () {
curl -s -o /tmp/lyric_curl.html $edited_url 2> /dev/null
first_result=$(cat /tmp/lyric_curl.html | grep -A 1 "<td><b>1" | grep -i "<a href=" | cut -d '"' -f 2)

# Make the curl request to the lyric website for the search results and save to a file

curl -s -o /tmp/lyrics.html -A "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5" $first_result 2> /dev/null
}

# Check if any results were returned or not (exit), if true (display lyrics)

function printlyrics () {
if [ ! -s /tmp/lyrics.html ]
	then
	echo "[*] No lyrics found :("; exit 0

# TODO: If no lyrics found, search another site or query some lyric API (potential re-write)

fi

# Sometimes it returns .html that is not lyrics (in /tmp/lyrics.html)
# If this happens, check for an identifier (submit corrections) that the page actually contains lyrics
# Potential TODO: This non-lyric containing .html page could be used to provide recommendations for other related songs by grepping for "/lyrics..." in href's if $search is not found

if grep -qi "Submit Corrections" /tmp/lyrics.html; then
echo "[*] Found Song Lyrics!"; echo ""
cat /tmp/lyrics.html | sed -n '/start of lyrics/,/end of lyrics\|^$\|pattern/p' | grep -B 100 "end of lyrics" | grep -v "start of lyrics" | grep -v "end of lyrics" | sed 's#<br />##g' | grep -v "<i>"; echo
echo "[*] End Song Lyrics"; echo
else
echo "[*] No lyrics found :("; exit 0
fi
}

function savelyrics () {
read -p  "[*] Would you like to save these lyrics to a file: [Y/N] " answer
	case $answer in
	[yY] | [yY][Ee][Ss] )
	      	read -p "[*] Enter a filename: [Ex. Band_Song.lyrics] " savename
		echo "[*] Saving lyrics to: `pwd`/$savename"
		touch $savename
		cat /tmp/lyrics.html | sed -n '/start of lyrics/,/end of lyrics\|^$\|pattern/p' | grep -B 100 "end of lyrics" | grep -v "start of lyrics" | grep -v "end of lyrics" | sed 's#<br />##g' | grep -v "<i>" >> `pwd`/$savename
               	;;

        [nN] | [n|N][O|o] )
		;;
	*)
		echo "[*} Invalid input"
		exit 0
       	        ;;
	esac
}

# Call all of the functions

ascii_art
query
urlquery
printlyrics
savelyrics
