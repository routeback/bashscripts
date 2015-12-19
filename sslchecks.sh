#!/bin/bash
# set -x
#
# Name: sslchecks.sh
# Auth: Frank Cass
# Date: 20151219
# Desc: TUI Interface for performing SSL checks of certificates and vulnerabilities
#
#	This script a WIP
#	Todo: Implement all checks 1-8
#	Todo: Implement checking for tool requirements before reaching main. See $require
#	Todo: Save all files to ssl_checks folder
#	Todo: Count total number of checks performed and echo at exit, pwd of ssl_checks
#	Todo: Implement ability to import a file, line delimeted $ip:$port - Specify full path
#	Goal: Try to keep it within 200 lines
#
###

# echo "$# parameters"
# echo "$@"

count=0
ip=$1
port=$2
require=curl,nmap,sslyze,openssl # Implement req. checks for all of the following
				 # If they don't have curl or openssl, cannot proceed. Must have one
				 # If they don't have nmap or sslyze, cannot proceed. Must have one
				 # echo You do not meet the following requirements:

function banner () {
	clear
	echo " ____ ____  _     ____ _   _ _____ ____ _  ______       _     "
	echo "/ ___/ ___|| |   / ___| | | | ____/ ___| |/ / ___|  ___| |__  "
	echo "\___ \___ \| |  | |   | |_| |  _|| |   | ' /\___ \ / __| '_ \ "
	echo " ___) |__) | |__| |___|  _  | |__| |___| . \ ___) |\__ \ | | |"
	echo "|____/____/|_____\____|_| |_|_____\____|_|\_\____(_)___/_| |_|"
	echo ""
	echo "       -= Quick SSL Checker TUI with file output =-"
	}

function target () {
	if [ $# -lt 2 ]
	then
		echo ""; echo "Usage: $0 IP Port"
		exit
	else
		currenttarget $1 $2 $count
	fi
}

function main () {
	if [ $count -gt 0 ]
	then
		echo "[*] Previous task complete!"
		echo "[*] Take your screenshot now and copy any necessary information"
		echo ""
		echo "Return to main menu?"
		echo "---y/n"
		read yn
		case $yn in
		[yY] | [yY][Ee][Ss] )
			echo "[!] Back to main menu in 5..."; sleep 0.5;echo "[!] 4.."; sleep 0.5;echo "[!] 3.."; sleep 0.5;echo "[!] 2.."; sleep 0.5;echo "[!] 1.."; sleep 0.5;
			;;
		[nN] | [n|N][O|o] )
			echo "[*] Exiting"; echo ""; exit
			;;
		*)
			echo "[*] I don't understand. To the main menu we go!"; sleep 2
		esac
		clear
	else
		count=`expr $count + 1`
	fi
banner
echo ""; echo "[*] -= SSLChecks.sh Main Menu =-"
echo "[*] Please select an SSL check to be performed"
echo "[*] Current Target: [$ip:$port]"
echo ""; echo "Vulnerabilities:"
echo "----1) SSLRenegotiation"
echo "----2) SSL POODLE"
echo "----3) LogJam"
echo "----4) FREAK"
echo ""; echo "Certificate Information"
echo "----5) Certificate Information"
echo "----6) Weak Hashing Algorithm"
echo ""; echo "Ciphers:"
echo "----7) All Ciphers"
echo "----8) Insecure Only (SSLv2/3, RC4, Null, Export)"
echo ""; echo "Options:"
echo "----C) Change Target"
echo "----Q) Quit"
read sslcheck
case $sslcheck in
# After selecting a choice, ex. FREAK or LogJam, give a brief description of the vulnerability
		1)
			sslreneg $1 $2
			;;
		2)
			;;
		[qQ])
			echo "[*] Exiting"; exit $?
			;; # Also listten for keystroke Ctrl+C break and do 9|ctrl+c
		[cC])
			setnewtarget
			;;
		*)
			echo "Invalid Option"
			;;
	esac
}

function currenttarget () {
	banner
	if [ $count -gt 0 ]
	then
	# echo "[*] Current Target: [$ip:$port]" # if [ -z ${var+x} ]; then echo "var is unset"; else echo "var is set to '$var'"; fi
	echo "[*] Change Targets [y/n]"
		read yn
		case $yn in
		[yY] | [yY][Ee][Ss] )
       	        	echo "Target change requested"
			setnewtarget
                	;;

		        [nN] | [n|N][O|o] )
        		        echo "No change in targets";
               			main
	                	;;

		        *) echo "Invalid input"
        		        ;;
			esac
	else
		# echo "[*] Current Target: [$ip:$port]"
		main
	fi
}

function setnewtarget () {
	echo "[*] Setting new target"
	echo "[!] Please enter an IP"; read ip
        echo "[!] Please enter a port"; read port
	main
# Unintended functionality when going back to main - Prints previous task complete; take screenshot, remove this message by jumping past it in main
# If newtarget=$newtarget+1, then do not print previous task complete
}

### SSL Check functions below ###

function supports_ssl () {
	# Perform a check if the server supports SSL/TLS connections or not. If it does not, provide the option to continue with the check anyway
	# If it does not support SSL/TLS, do not continue with the check, and call setnewtarget, then return to main
	echo "[*] Checking for SSL/TLS support..."
	status="$(openssl s_client -connect $ip:$port)"
	grep -q refused "$status"
#       if [[ $status == *"Connection refused"* ]]
#	if grep -q "Connection refused" <<<status=$(openssl s_client -connect $ip:$port); then # timeout 30s, if exit code failure then goto SSL/TLS not supported, timeout 30s $status
#		no_ssl_support
#	else
#		echo "[*] Server appears to support SSL/TLS connections"
#	fi
}

function no_ssl_support () {
echo "[*] It appears this host does not support SSL/TLS connections."
setnewtarget
}

function sslreneg () {
echo "[*] -= SSL Renegotiation Checker =-"
supports_ssl
sslyze --reneg $ip:$port | tee $ip.$port.sslyze
echo "[*] Saved as $ip.sslyze"
main
}

function certinfo () {
echo "[*] -= SSL Certificate Information =-"
supports_ssl
sslyze --certinfo=basic $ip:$port | tee $ip.certinfo # Ask for full or basic information?
echo "[*] Certificate information saved as $ip.certinfo"
main
}

function nmap_cert_info () {
echo "[*] -= Nmap Certificate information scanner =-"
supports_ssl
nmap -p $port -sV --script=ssl-cert.nse $ip -oN $ip.nmap_certificate
main
}

function nmap_poodle () {
echo "[*] -= Nmap SSL POODLE Scanner =-"
supports_ssl
nmap -p $port -sV --script=ssl-poodle.nse $ip -oN $ip.nmap_poodle # Add checking for ssl-poodle script
# You do not have ssl-poodle.nse in your /usr/share/nmap/scripts folder. Download it with
# wget -o ssl-poodle.nse <address>, then cp ssl-poodle.nse /usr/share/nmap/scripts; nmap --update-db # Then return to main
main
}

#function s_client_cert () {
# echo | openssl s_client -connect $ip:$port 2>/dev/null | openssl x509 -noout -issuer -subject -dates
# echo | openssl s_client -connect $ip:$port 2>/dev/null | openssl x509 -noout -text #Full output
#}

target $1 $2
main $1 $2
