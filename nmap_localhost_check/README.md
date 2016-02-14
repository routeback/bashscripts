# Localhost nmap scanning research #

Name: 

	nmap_localhost_check

Files: 

	README
	scan.sh
	logs/nc_connect.txt
	logs/scan.gnmap
	logs/scan.nmap
	logs/scan.xml

## Intro ##

tl;dr This is a quick script to automate scanning the localhost NUM times with nmap and then checking each "open" port with netcat.

*It's possible that these results are skewed by the out of date host and version of nmap used and could have been a bug that was already patched*

## Detailed ##

When I was performing some localhost nmap scans I saw odd high TCP ports open and wanted to investigate.
Not only did I find these open high port numbers strange, they changed dymanically with each nmap scan.
In addition, each netcat connection revealed a "Connection Refused".
This script automates the nmap and netcat scanning process for quick "open" port analysis.

## Analysis Questions ##

Is there any statistical correlation between the open ports that are found? 

What would the results be after scanning the localhost 35535+ times, exceeding the expected exclusive open port range? 
If so, would there be a duplicate "open" port entry??

## Notes ##

*All information from nmap and netcat is output and appended to the logs folder for reference.

*The "open" ports range seems to be between TCP 30000 - 65535 exclusively.

*Attempting to background / thread nmap with & when running the loop resulted in the testing VM to freeze, most likely due to memory / CPU limits imposed by the host VM software.

*The -sT (TCP Scan)  option is used with nmap as it was the first option to successfully detect the open ports

*Current estimates for running this script to scan the localhost 35536 times at ~0.20s per scan is approximately 118 minutes.

## Tested on ##

	* Host: Linux kali 3.18.0-kali3-586 #1 Debian 3.18.6-1~kali2 (2015-03-02) i686 GNU/Linux
	* Nmap: 6.47

## Usage Example ##

	`./scan.sh`

		> [*] Name: scan.sh
		> [*] Desc: Scan localhost with nmap multiple times then netcat to each open port
		> [*] Number of nmap scans 35536
		> [*] Port range 30000-65535
		> [*] Scanning in 5 seconds
		> 
		> [...snip...]
