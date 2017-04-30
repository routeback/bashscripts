#!/bin/sh
#
# Name: robots_scraper.sh
# Auth: Frank Cass
# Date: 20151227
# Desc: Scrape robots.txt from targets.list in the form of IP:PORT
#
# 	TODO: Implement parsing of robots.txt output files to remove unnecessary or blank lines and spaces, option to remove comments as well
# 	TODO: Search through all robots.txt files for interesting directories, common/default installations, install.txt, readme.txt, if found wget $i/$interesting
#	TODO: When parsing, if wget = error or saved robots.txt file is 0 bytes, remove it
#	TODO: Pretty table of which hosts do have a robots and those who don't
# 	TODO: Implement checking for default robots.txt file to save time when manually reviewing, read from file for example of what default looks like
#	TODO: Add additional check for just robots without .txt extension, if found, append to the robots.$IP file
# 	TODO: echo at end of output [*] Total hosts found to have robots.txt file: $hasrobots
#	TODO: If hostname is provided (check for non numeric input) then ping the host once for the IP (ping timeout 2second) to include with output for reference
# 	TODO: If hostname is provided, only output the domain name, not http://www or .com
#	TODO: Ability to discern HTTPS:// & 443--Check for HTTPS, try and if fail then fallback to HTTP
#	TODO: Implement check with WC for file to contain > 0 lines of data & read access, check for nonzero exit code (failure)
#	TODO: Test outputting to single file, or multiple files. When printing ip:port, use alternative to :
#	TODO: Add checking each robots file for sitemap.xml, if found, say X of the N searched sites contain robots with sitemap info, retrieve / spider this information?
#	TODO: Ability to specify the user agent as a VAR in the script or as read input
#	TEST: Hostname list and : port
#	TEST: IP:PORT, IP
#
#
###

echo ""; echo " NOTE: This script is still in development and may not be fully functional!"
echo ""; echo "		-= robots_scraper.sh =-"; echo ""
echo " Description: Quickly scrape a list of IP addresses for their robots.txt file, if it exists."; echo ""
echo " [*] Input a full path to a line delimeted file containing IPs in the format of IP:PORT"
echo " [*] Final Output will be save in the current directory as robots.IP"
echo " [!] NOTE: Port optional, default is 80. If the file path contains spaces, use quotes"; 
echo "           Ex. \"/root/path to targets.txt\"" ; echo ""
read file
lines=$(wc -l $file)
echo ""; echo "[*] File contains $lines lines of input. Checking for robots.txt..."; echo ""
for i in $(cat $file); do wget --timeout=15 -O robots."$i" "$i/robots.txt"; done
for i in $(cat file); do echo "[*] Output saved to: `pwd`/robots."$i
echo "[*] Done"; echo ""
