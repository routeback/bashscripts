#!/bin/bash
# set -x
#
# Name: sslchecks.sh
# Auth: Frank Cass
# Date: 20151217
# Desc: TUI Interface for performing SSL checks of certificates and vulnerabilities
#
###

echo "$# parameters"
echo "$@"

count=0
ip=$1
port=$2

function banner () {
	echo " ____ ____  _     ____ _   _ _____ ____ _  ______       _     "
	echo "/ ___/ ___|| |   / ___| | | | ____/ ___| |/ / ___|  ___| |__  "
	echo "\___ \___ \| |  | |   | |_| |  _|| |   | ' /\___ \ / __| '_ \ "
	echo " ___) |__) | |__| |___|  _  | |__| |___| . \ ___) |\__ \ | | |"
	echo "|____/____/|_____\____|_| |_|_____\____|_|\_\____(_)___/_| |_|"
	echo ""
	echo "[*] Quick SSL Checker TUI with file output"
}

function main () {
echo "[*] SSLChecks.sh Main Menu"
	if [ $count -gt 0 ]
	then
		echo "[*] Previous task complete"
	else
		count=`expr $count + 1`
	fi
echo "[*] Please select an SSL check to be performed"
echo "----1) SSLRenegotiation"
echo "----2) Selection 2"
echo "----9) Quit"
	read sslcheck
	case $sslcheck in
		1)
			echo "[*] SSL Renegotiation Check Selected"
			sslreneg $1 $2
			;;

		2)
			echo "Selection 2"
			;;

		9)
			echo "[*] Exiting"; exit $?
			;; # Also listten for keystroke Ctrl+C break and do 9|ctrl+c

		*)
			echo "Invalid Option"
			;;
	esac
}

function target () {
	if [ $# -lt 2 ]
	then
		echo "Usage: $0 IP Port"
		exit
	else
		currenttarget $1 $2 $count
	fi
}

function currenttarget () {
	banner
	if [ $count -gt 0 ]
	then
		echo "[*] Current Target: [$ip:$port]" # if [ -z ${var+x} ]; then echo "var is unset"; else echo "var is set to '$var'"; fi
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
		echo "[*] Current Target: [$ip:$port]"
		main
	fi
}

function setnewtarget () {
		echo "Please enter an IP"; read ip
                echo "Please enter a port"; read port
		main
}

function s_client_cert () {
# echo | openssl s_client -connect $ip:$port 2>/dev/null | openssl x509 -noout -issuer -subject -dates
# echo | openssl s_client -connect $ip:$port 2>/dev/null | openssl x509 -noout -text #Full output
}

function sslreneg () {
echo "[*] SSL Renegotiation Checker"
sslyze --reneg $ip:$port | tee $ip.sslyze
echo "[*] Saved as $host.sslyze"
main
}

function certinfo () {
echo "[*] SSL Certificate Information"
sslyze --certinfo=basic $ip:$port | tee $ip.certinfo # Ask for full or basic information?
echo "[*] Certificate information saved as $ip.certinfo"
main
}

function nmap_cert_info () {
echo "[*] Nmap Certificate information scanner"
nmap -p $port -sV --script=ssl-cert.nse $ip -oN $ip.nmap_certificate
main
}

function nmap_poodle () {
echo "[*] Nmap SSL POODLE Scanner"
nmap -p $port -sV --script=ssl-poodle.nse $ip -oN $ip.nmap_poodle # Add checking for ssl-poodle script
# You do not have ssl-poodle.nse in your /usr/share/nmap/scripts folder. Download it with
# wget -o ssl-poodle.nse <address>, then cp ssl-poodle.nse /usr/share/nmap/scripts; nmap --update-db # Then return to main
main
}

target $1 $2
main $1 $2
