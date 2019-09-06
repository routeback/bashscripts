#!/bin/bash
#
# Name: getdns.sh
# Auth: Frank Cass
# Date: 20190906
# Desc: Quickly retrieve Internet accessible data from a list of hosts for OSINT purposes.
#
###

# Below: Extreme scope-creep of what this tool was intended for and what is has since  become.
#
# TODO: Re-write the script as functions that are called through positional parameters
# EX:	--dns
#	--whois
#	--cms
#	--robots,sitemap,content-discovery
#	--all
#	--output filename
#
	# This can allow the tool to work well for internals as well by ignoring whois checks etc. by only using local scanning functions w/ Nmap etc. and by specifying an internal DNS server for name resolution. 
	# Additionally, this tool can have internal specific functions like NBTScan, broadcast scanning etc. However, this may overlap with existing tooling such as Discover and Rumble and may not be necessary, though having a single functioning script with minimal setup that is easily portable can be of value.
#
# Database integration and thoughts - Data aggregation and correlation
	# Log each command that is executed and use a primary key ID value to associate it with the expected output, if expected output is null, then re-run command where key ID = n
	# Separate DB gap analysis script, allows you to re-scan the DB following all executed tasks, identify missing fields and attempt to retrieve them once more.
	# If secondary attempt fails, do not try again and flag bit for manual review.
	# Continue this methodology with fingerprinting services and manually reviewing them.
	# Implementation: set -x can reveal command, or find a way to pull the local history within the subshell and log it. Will have to grep the $i hostname to identify legit commands and assign them a new primary key.
#
# Logging & Reference Data / History
	# Find a way to then store historical values for each cell, run these scans on a regular interval, and then send email diff's and screenshots of content or headers etc. that changed
	# Also tie this in with subdomain bruting and other new host detection scripts, automatically adding those hosts into the in-scope asset monitoring pool
	# Monitor webheaders and other parameters for changes to notify of newly deployed software.
#
# Implement a CTRL+Break catch at any point in the script to prompt the user with y/n and enter to actually quit, otherwise it will continue to prevent accidental cancellation.
#
# Efficiency: Make a Wordpress scanner (xmlrpc, wp-login, Wordpress headers etc.) to identify if a site is WP based or not, then use those hosts for CMSmap and add -f W parameter.
# cmsmap -o cmsmap_scans/$i.cmsmap -s -d -a "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36" http://$i
# echo "[*] CMSmap completed. Check cmsmap_scans/$i.cmsmap file for details." | tee -a $filename
#
# Most important data points to extract from nmap output and log to DB:
	# rDNS record for 127.0.0.1: example.com - 				# If new IP / Domain, add to a manual scope review list, then re-scan if necessary.
	# PORT    STATE SERVICE  VERSION
	# 443/tcp open  ssl/http nginx 1.x.x
	# |_http-server-header: nginx/1.x.x
	# | ssl-cert: Subject: commonName=example2.com
	# | Subject Alternative Name: DNS:example.com, DNS:www.example3.com
#
# Automated reporting should be a default and expected feature of the tool for manually reviewing and editing data.
# Final output of all tools should be XML for simple parsing.
# Next step of this project may be parsing the $filename for [*] and then formatting it to XML, then creating a custom XSL and rendering it, which can then be copy/pasted into Word as a table or used with Markdown to generate a PDF.
#
# Create a separate script for scanning ports and services once scope is finalized
#	- Just use Discover, but find a way to run it without the TUI, how can you supply all the parameters it needs from CLI and run MSF auxiliaries etc?
#	- If not possible, just instruct the user to next run discover and provide the path: /opt/discover/discover.sh
# Once all banners are retrieved, use searchsploit equivalent GO tool and provide list of CVE's to inspect and high priority targets
#
# Separate output to individual hostnames, change loops to output to hostname.all_tool_appended_output instead of a single flat file.
#
# IP Address:
# Country: US
# State: Illinois
# City: Chicago
#
######################################################################################################################################################

clear; echo "[*] $0: Bulk Open Source Intelligence Recon Script."

# Check if user supplied a path to a line delimeted file.
if [ "$1" = "" ]; then
 	echo "[*] EXIT: Please provide a line-delimited list of hostnames"
	echo "[*] Example usage: $0 /path/to/hosts.txt"
	exit 1
fi

# Check if the file exists
if [ -f $1 ]
then
	: # Do nothing if the file actually exists.
else
	 echo "[!] EXIT: File does not exist. Please provide a line delimeted list of hostnames."
	 exit 1
fi

# Check if more than one parameter is provided
if [[ "$#" -gt 1 ]]; then
	echo "[!] EXIT: More than one parameter specified. Try again."
        exit 1
fi

# Save the output to a file, allow the user to choose to overwrite or not
filename=Recon-$1.txt
if [ -f $filename ]; then
        echo -n "[*] Output file $filename exists. Overwrite? (y/n): "
        read response
        if printf "%s\n" "$response" | grep -Eq "$(locale yesexpr)"; then
                echo "[*] File overwrite enabled."
		rm $filename; touch $filename
        else
		echo "[*] Backup $filename or remove this check from the script to proceed."
                echo "[!] EXIT: Not overwriting existing file."
                exit 1
        fi
fi

# Define a function that can be repeatedly used
# If the tool fails, alert to the user and exit
function failcheck() {
	if [[ $? -ne 0 ]]; then
	        echo "[!] EXIT: Something went wrong!"
	        exit 1
	fi
}

# Requirements
# TODO: Create an array of tool names, use a loop to check if it is installed, attempt to install it instead of manually checking for each req.
which dig &>/dev/null
if [[ $? -ne 0 ]]; then
        echo "[*] Try 'apt install -y dnsutils'"
        echo "[!] EXIT: dig needs to be installed to run this script!"
        exit 1
fi

which whois &>/dev/null
if [[ $? -ne 0 ]]; then
        echo "[*] Try 'apt install -y whois'"
        echo "[!] EXIT: whois needs to be installed to run this script!"
        exit 1
fi

which openssl &>/dev/null
if [[ $? -ne 0 ]]; then
        echo "[*] Try 'apt install -y openssl'"
        echo "[!] EXIT: openssl needs to be installed to run this script!"
        exit 1
fi

which whatweb &>/dev/null
if [[ $? -ne 0 ]]; then
        echo "[*] Try 'apt install -y whatweb'"
        echo "[!] EXIT: whatweb needs to be installed to run this script!"
        exit 1
fi

which nmap &>/dev/null
if [[ $? -ne 0 ]]; then
        echo "[*] Try 'apt install -y nmap'"
        echo "[!] EXIT: nmap needs to be installed to run this script!"
        exit 1
fi

which sponge &>/dev/null
if [[ $? -ne 0 ]]; then
        echo "[*] Try 'apt install -y moreutils'"
        echo "[!] EXIT: sponge needs to be installed to run this script!"
        exit 1
fi

# Identify if Eyewitness is cloned locally or not.
eyewitness=$(locate '*/.git' | grep -i Eyewitness | grep -v var | sed 's/\/.git//g')
if [ "$eyewitness" = "" ]; then
        echo "[*] Try 'git clone https://github.com/FortyNorthSecurity/EyeWitness'"
	echo "[*] It is recommended to update your geckodriver. Here's a shortcut: "
	echo "[*] https://github.com/routeback/bashscripts/blob/master/remote_testing_appliance/geckodriver_update.sh"
        echo "[!] EXIT: Eyewitness needs to be installed to run this script!"
        exit 1
fi

# Begin gathering data by looping through lines in file
if [ "$1" != "" ]; then
	for i in $(cat $1); do
	echo "[*] Starting recon for: $i" | tee -a $filename
	echo "" | tee -a $filename
# TOOD: DIG - Bug identified with missing A records - Test grep awk sed to see which is removing it, or if this is a false positive.
# May want to cycle a few major DNS servers to ensure comprehensive coverage, is there a public API that could be queried instead?
# How can this data be combined with existing OSINT tools such as Spiderfoot? Is it worthwhile to continue developing this standalone tool or acquire multiple API keys for an automation platform?
 	echo "[*] DNS Records for: $i" | tee -a $filename
	dig @8.8.8.8 -t any +nocmd +noclass +nottlid $i | grep -v ";\|;;" | awk '{$1=$1}{ print }' | sed '/^\s*$/d' | grep -v root-servers.net | tee -a $filename
	echo "" | tee -a $filename
# WHOIS
	echo "[*] WHOIS Records for: $i" | tee -a $filename
	whois $i | grep -i -E 'netname:|origin:|route:|descr:|organization:|netrange:|Expiry|admin email|tech email|phone:' | awk '{$1=$1}{ print }' | tee -a $filename
	echo "" | tee -a $filename
# SSL Certificate Alternative Names
# Does not account for websites not hosted on 443 - Find a better way to identify what the full url would look like and parse that to openssl, e.g. https://localhost:8443
# Does not allow scanning of hosts that only support insecure SSLv2 etc., may not work for untrusted certificates
	echo "[*] [OpenSSL] SSL Certificate Alternative Names for: $i" | tee -a $filename
	openssl </dev/null 2>/dev/null s_client -showcerts -servername $i -connect $i:443 | openssl x509 -inform pem -noout -text 2>/dev/null | grep -A1 'X509v3 Subject Alternative Name' | grep -v 'X509v3 Subject Alternative Name' | sed 's/DNS://g' | sed 's/,/\n/g' | awk '{$1=$1}{ print }' | tee -a $filename
	echo "" | tee -a $filename
# Nmap Scanning for additional coverage: SSL Certificate Information, Common names, Expiration, Robots.txt, Vhosts, Private IP leak
	echo "[*] [Nmap] Retrieving Certificate Common Names, VHOSTS, Robots.txt, Private IP leak and Forward-confirmed reverse DNS: $i" | tee -a $filename
	nmap -p 443 $i --stats-every 2s -sV --script ssl-cert-intaddr.nse,ssl-cert.nse,fcrdns.nse,http-vhosts.nse,http-robots.txt.nse --initial-rtt-timeout=30s --max-rtt-timeout=30s --host-timeout=30s --max-retries 3 | tee -a $filename 
	echo "" | tee -a $filename
# WhatWeb to identify CMS
	echo -n "[*] Performing WhatWeb of host: $i" | tee -a $filename
	echo "" | tee -a $filename
	whatweb --color=never -a 3 -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36" $i --url-suffix /crossdomain.xml | sed 's/, /\n/g' | sed 's/,/\n/g' | tee -a $filename # --log-errors=error.log --url-suffix /robots.txt --url-suffix /sitemap.xml
	# If this fails on a particular host, alert echo "[*] Looks like there is nothing to see here...: ($i)"
	# If this fails, it's likely because there is no live content, in which case you can trigger a retrieval of the most recent 3 captures from an archival service
	# Should capture stderr (and ensure tool prints to stderr and not just output regardless of it failing)
	#echo "[*] WhatWeb Error Log: " >> $filename; cat error.log >> $filename; rm error.log
	echo "" | tee -a $filename
# TODO: Implement the following:
	# Include OWASP Amass and include a check for the repo and installation as seen earlier in this script but for Eyewitness: https://github.com/OWASP/Amass
	# Rather than writing checks for tools like this, develop a dockerfile or other build automation tool that can then be ran directly.
	# Use https://bitbucket.org/al14s/rawr/wiki/Usage for scripted web checks
	# Use gobuster against known WAPPs with a custom worldlist of high priority URLs (admin/login/management etc.)
	# Use TOR or another service for remote Geo-Accessibility via US,CH,RU,EU
	# DNS Dumpster searching
	# Scanning for S3 buckets
	# Scanning for old pastebin links
	# Scanning for public records (filings, registrations, other discover google dorks)
	# Identify company social media profiles, glassdoor, twitter, facebook etc, linkedin
	# Dorking, Scanning websites and domains for cached documents list (but don't retrieve them, just provide a list of URLs for manual review or scraping later)
	# Create an additional script that can monitor a folder "[*] Monitoring `pwd` for new documents to parse with Exiftool..."
	# Scanning for missing security headers / best practices.
	# Strict transport security, HSTS, XSS Blocking header, CSRF Tokens, Secure Cookies - There was a python script that automated all these checks, or could be a good exercise in writing a web scraper in GO.
	# Shodan, Censys
	# Github data searching for the company name, individual employee pages
	# Query HaveiBeenPwned directly (muiltiple tools for this, API key may be easiest, but then if so why do any of this OSINT with this tool? Use Spiderfood instead and learn how to massage that data into something usable.
	# Separate Bing search for full coverage, once again API to prevent lockout.
	# Archive.net
	# Darknet search for breaches / other information pertaining to the company
	# Wigle access point list, location information, financials (SEC filings, other public business record scraping)
	# Manual review for ADFS / Skype / OWA / VPN - Check for 2FA, find domain, PW Spray, PW reset logic
	# Implement checks for ADFS/Autodiscover/Lync/Skype/O365/OWA
	# Scan for Lync Servers: for i in $(cat wapps); do echo "[*] Scanning $i: "; curl -ILk -m 10 https://lyncdiscover.$i; done # Look for HTTP 405 Method not allowed. Potential Lync Endpoint Found: [*] $ip
	# Federated services / SSO Scanner - O365, Skype, Exchange, Azure AD, SharePoint, Lync, AD-FS / Other Apps
	# WAPPs for manual review / testing w/ Commix and burp collaborator, arachnai
	# Then parse final output to markdown, a spreadsheet or database, then generate reports in HTML, Markdown and PDF and word tables.
	# Need to add multiple DNS servers for querying, if output is null, then try next in DNS list, if WHOIS null, try another server or use cache-db (find a repo of whois data to clone daily/weekly), fix mkdir in CMSmap loop
	# Query headers for known software regex (literally just numbers) and if found do searchsploit and populate the output of this command with 'potential vulns' and then have a 'confirmed vulns' tab that lists CVE's that then get automatically reported based on the official CVE information (separate query script).
	done
fi

# Web Screenshot
	echo "[*] Using Eyewitness to screenshot assets. This may take some time." | tee -a $filename
	"$eyewitness"/./EyeWitness.py --web -f $1 --prepend-https --no-prompt --timeout 15 -d eyewitness --resolve --active-scan &>/dev/null
	echo "[*] View Eyewitness output here: eyewitness/report.html" | tee -a $filename
	echo "" | tee -a $filename
	failcheck
	rm geckodriver.log

# Parse out unnecessary nmap output
cat dns_info.txt | grep -v "Service scan Timing\|Ping Scan Timing\|undergoing Ping Scan\|undergoing Service Scan" | sponge dns_info.txt
echo "[*] Tasks completed at `date`." | tee -a $filename
echo "[*] Report generated as $filename."
