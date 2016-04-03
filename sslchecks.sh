#!/bin/bash
#
# Name: sslchecks.sh
# Auth: Frank Cass
# Date: 20160412
# Desc: TUI Interface for performing SSL checks of certificates and vulnerabilities
#
#	Todo: Count total number of checks performed and echo at exit
#	Todo: Implement ability to import a file, line delimeted $ip:$port - Specify full path
#		Currently only supports single target manual IP entry. Want it to be flexible between single IP targets and performing checks against all hosts in a file and generating useful output
# 	Todo: Main menu option to toggle saving output to files or to stdout only
#		[F]ile Saving [On]/Off
#	Thoughts: Should it be aware if a host has been previously checked? Ex. checking current directory for .sslchecks files regarding certificate info or other
#	Thoughts: File output could be combined into a single file for all of the checks performed against a single host with regex for searching information regarding a host (Ex. press X for certificate expiry of this host)
#
###

# echo "$# parameters"  # Troubleshooting
# echo "$@"		# Troubleshooting

count=0
ip=$1
port=$2
fileoutput=On

# require=curl,nmap,sslyze,openssl # Implement req. checks for all of the following
				   # If they don't have curl or openssl, cannot proceed. Must have one
				   # If they don't have nmap or sslyze, cannot proceed. Must have one
				   # echo You do not meet the following requirements:
				   # From SSLyze Github
				   # SSLyze is all Python code but since version 0.7, it uses a custom OpenSSL wrapper written in C called nassl. The pre-compiled packages for SSLyze contain a compiled version of this wrapper in sslyze/nassl. If you want to clone the SSLyze repo, you will have to get a compiled version of nassl from one of the SSLyze packages and copy it to sslyze-master/nassl, in order to get SSLyze to run.
				   #The source code for nassl is hosted at https://github.com/nabla-c0d3/nassl.

function banner () {
	clear
	echo " ____ ____  _     ____ _   _ _____ ____ _  ______       _     "
	echo "/ ___/ ___|| |   / ___| | | | ____/ ___| |/ / ___|  ___| |__  "
	echo "\___ \___ \| |  | |   | |_| |  _|| |   | ' /\___ \ / __| '_ \ "
	echo " ___) |__) | |__| |___|  _  | |__| |___| . \ ___) |\__ \ | | |"
	echo "|____/____/|_____\____|_| |_|_____\____|_|\_\____(_)___/_| |_|"
	echo ""
	echo "	-= Quick SSL/TLS Vulnerability Checker =-"
	}

function target () {
	if [ $# -lt 2 ]
	then
		echo "Usage: sslchecks.sh <IP> <Port>"
		exit
	else
		currenttarget $1 $2 $count
	fi
}

function check_counter () {
		echo "[*] Previous task complete!"; echo ""
		read -p "[*] Return to main menu? [y/n] " yn; case $yn in
		[yY] | [yY][Ee][Ss] )
			;;
		[nN] | [n|N][O|o] )
			echo "[*] Exiting"; echo ""; exit
			;;
		*)
			echo "[*] Returning to main menu"; sleep 2
		esac
		clear
}

function main () {
banner
echo ""
echo "[!] NOTE: This script is still in development!"
echo ""; echo "Vulnerabilities:"
echo "----1) SSLRenegotiation"
echo "----2) SSL POODLE"
echo "----3) LogJam"
echo "----4) FREAK"
echo ""; echo "Ciphers:"
echo "----5) All Ciphers"
echo "----6) Insecure Only (SSLv2/3, RC4, Null, Export, Anon)"
echo ""; echo "Certificate Information"
echo "----R) Retrieve Certificate Information"
echo "----W) Weak Hashing Algorithm"
echo "----X) Certificate Expiry"
echo ""; echo "Options:"
echo "----C) Change Target"
echo "----F) Toggle file saving: [$fileoutput]"
echo "----S) Check for SSL/TLS support"
echo "----Q) Quit"
echo ""
echo "[*] File output to: `pwd`"
echo "[*] Current Target: [$ip:$port]"
echo ""

read -p "Please input a selection: " sslcheck
case $sslcheck in

# After selecting a choice, ex. FREAK or LogJam, give a brief description of the vulnerability

		1)
			sslreneg $1 $2
			;;
		2)
			nmap_poodle $1 $2
			;;
		3)
			logjam $1 $2
			;;
		4)
			freak $1 $2
			;;
		5)
			ciphers_full $1 $2
			;;
		6)
			ciphers_insecure  $1 $2
			;;
		[rR])
			certificate_basic $1 $2
			;;
		[wW])
			weak_hashing $1 $2
			;;
		[qQ])
			echo "[*] Exiting"; exit $? # Should this be return instead to prevent closing the terminal?
			# Also listten for keystroke Ctrl+C break
			;;
		[cC])
			setnewtarget
			;;
		[fF])   # Toggle switch for file saving on / off
#			if [ $fileoutput=true ]; then fileoutput=false
#			else
#			if fileoutput=false; then fileoutput=true; done; fi
#			fi
#			Change output path to NULL
#			Off by default, if pressed, specify an output folder
			main
			;;
		[sS])
			supports_ssl $1 $2
			;;
		[xX])
			certificate_expiry $1 $2
			;;
		*)
			echo ""; echo -n "[*] Invalid Option"; for i in $(seq 1 10); do echo -n "."; sleep 0.15; done
			main
			;;
	esac
}

function currenttarget () {
	banner
	if [ $count -gt 0 ] # Still needed?
	then
	# echo "[*] Current Target: [$ip:$port]" # Old notes: if [ -z ${var+x} ]; then echo "var is unset"; else echo "var is set to '$var'"; fi
	echo "[*] Change Targets [y/n]"; read yn; case $yn in
		[yY] | [yY][Ee][Ss] )
       	        	echo "Target change requested"
			setnewtarget
                	;;

	        [nN] | [n|N][O|o] )
       		        echo "No change in targets";
      			main
	               	;;

	        *)
			echo ""; echo -n "[*] Invalid Option"; for i in $(seq 1 10); do echo -n "."; sleep 0.15; done
        	        ;;
		esac
	else
		main
	fi
}

function setnewtarget () {
	echo ""
	echo "[*] Setting new target"
	read -p "[*] Please enter an IP or hostname: " ip
        read -p "[*] Please enter a port: " port
	echo "[*] Target changed! Returning to main menu..."
	sleep 2
	main
}

### SSL/TLS Check functions below ###

function supports_ssl () {
	# Perform a check if the server supports SSL/TLS connections or not.
	# If it does not, provide the option to change targets (setnewtarget)
	# If targets are unchanged, provide the option to continue with the check anyway (force) or goto main menu
	echo ""; echo "[*] Checking for SSL/TLS support..."; echo ""
	ssl_connect="openssl s_client -connect $ip:$port 2> /dev/stdout" # ALT: curl --ssl-reqd -s -S https://$ip:$port | grep couldn't
	timer="timeout 3s"
	refused="$ssl | grep -q \"refused\""
	accepted="$ssl | grep -i \"SSL handshake\""
	echo "CURRENT EXIT CODE IS:" $? # Troubleshooting
	# $refused # Check for refused, if so then jump to no_ssl_support. If not refused, perform the check again looking for the SSL/TLS handshake
	if [[ $? == 0 ]] # If grep exit code is 0 because it found Connection refused, then goto no_ssl_support
	then
		no_ssl_support
	else
		echo "[*] Appears to support SSL, looking for SSL handshake..."
		$accepted # Check for accepted SSL Handshake, if not ssl handshake exit code 0 then run again once without grep for full output
		echo "[*] Server $ip:$port appears to support SSL/TLS connections"
	fi
}

# If supports_ssl is called from main menu and server does support SSL/TLS, does the script continue to the next function at no_ssl_support?

function no_ssl_support () {
	echo ""; echo "[!] It appears this host does not support SSL/TLS connections."; echo ""
	read -p "[*] Would you like to set a new target? [y/n]: " yn; case $yn in
	[yY] | [yY][Ee][Ss] )
		setnewtarget
		;;
	[nN] | [n|N][O|o] )
		echo ""
		echo "[*] Target unchanged. Force SSL Check or return to Main Menu?"
		echo "---[F]orce / [M]ain / [Q]uit"; read choice; case $choice in
			[fF])
				echo "[!] This option does not currently work. Sleeping 3 seconds"; sleep 3
				# How to force the check when the checks all begin with supports_ssl function?
				# Shouldn't have to add any code for this, no_ssl_support should finish and then continue with the check
				;;
			[mM])
				main
				;;
			[qQ])
				echo "[*] Exiting."
				exit
				;;
			esac
		;;
	*)
		echo ""; echo -n "[*] Invalid Option"; for i in $(seq 1 10); do echo -n "."; sleep 0.15; done
		;;
	esac
}

function sslreneg () {
	clear
	echo ""; echo "[*] -= SSL Renegotiation Checker =-"
	supports_ssl
	( set -x; sslyze --reneg $ip:$port | tee $ip.$port.sslyze )
	echo "[*] Saved as $ip.sslyze"
	check_counter
}

function nmap_poodle () {
	clear
	echo "[*] -= SSL/TLS POODLE Vulnerability Check =-"
	supports_ssl
	( set -x; nmap -Pn -p $port -sV --script=ssl-poodle.nse $ip -oN $ip.nmap_poodle )
	echo ""; echo "[*] Saved as $ip.nmap_poodle"
	# Add checking for ssl-poodle script | while grep nmap if stderr throws nscript not found, goto ssl-poodle.nse_missing ()
	# You do not have ssl-poodle.nse in your /usr/share/nmap/scripts folder. (Would you like to) Download it with
	# wget -o ssl-poodle.nse <address>, then cp ssl-poodle.nse /usr/share/nmap/scripts; nmap --update-db # Then return to main
	check_counter
}

function logjam () {
	clear
	echo ""; echo "[*] -= SSL/TLS LogJam Check =-"
	supports_ssl
	( set -x; openssl s_client -connect $ip:$port -cipher "EXP" | tee $ip.logjam )
	echo ""; echo "[*] Saved as $ip.logjam"
	check_counter
}

#function freak () {
# ( set -x; )
#}

# Menu option #5 - To be combined with number 6 to automatically check for the weak hashing algorithm
function certinfo () {
	clear
	echo ""; echo "[*] -= SSL Certificate Information =-"
	supports_ssl
	( set -x; sslyze --certinfo=basic $ip:$port | tee $ip.certinfo ) # Ask for full or basic information?
	echo "[*] Certificate information saved as $ip.certinfo"
	check_counter
}

# Menu option #n - To replace 6 as an alternate certificate information grabber
function nmap_cert_info () {
	clear
	echo ""; echo "[*] -= Nmap Certificate information scanner =-"
	supports_ssl
	( set -x; nmap -p $port -sV --script=ssl-cert.nse $ip -oN $ip.nmap_certificate )
	check_counter
}

function ciphers () {
	supports_ssl
	# ( set -x; )
	check_counter
}

# Check for CRIME, FREAK, LogJam, Export, Heartbleed
function insecure_ciphers () {
	supports_ssl
	# ( set -x; )
	check_counter
}

function certificate_expiry () {
	supports_ssl
	# Could implement another small TUI for what kind of checks
	# openssl s_client -connect $ip:$port 2>/dev/null | openssl x509 -noout -issuer -subject -dates
	# Other openssl s_client options: -purpose, -ignore_critical, -issuer_checks, -crl_check, -crl_check_all, -policy_check, -extended_crl, -x509_strict, -policy -check_ss_sig
	( set -x; timeout 3s openssl s_client -connect $ip:$port 2>/dev/null | openssl x509 -noout -text | grep -i -A 1 "Not Before" )
	check_counter
}

target $1 $2
main $1 $2

# NEW CHECKS

#MS14_066_CIPHERS="DHE-RSA-AES256-GCM-SHA384 DHE-RSA-AES128-GCM-SHA256 AES256-GCM-SHA384 AES128-GCM-SHA256"
# Ciphers supported by Windows Server 2012R2
#WINDOWS_SERVER_2012R2_CIPHERS="ECDHE-RSA-AES256-SHA384 ECDHE-RSA-AES256-SHA"

# Test if OpenSSL does support the ciphers we're checking for...
#echo -n "Testing if OpenSSL supports the ciphers we are checking for: "
#openssl_ciphers=$(openssl ciphers)

#MS14_066 Ciphers
#
#for c in $MS14_066_CIPHERS
#do
#  if ! echo $openssl_ciphers | grep -q $c 2>&1 >/dev/null
#  then
#    echo -e "\033[91mNO (OpenSSL does not support $c cipher.)\033[0m"
#    echo -e "\033[91mAborting."
#    exit 5
#  fi

