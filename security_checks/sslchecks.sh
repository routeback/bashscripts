#!/bin/bash
# set -x # Troubleshooting
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
# 	Todo: Main menu option to toggle saving output to files or to stdout only
#		[F]ile Saving [On]/Off
# 	Todo: Implement subshell with set -x enabled for each of the checks to print out the command that was used
#	Todo: Implement main menu option for checking SSL/TLS support - goto supports_ssl (good for troubleshooting)
#	Todo: Implement coloring of the vulnerable text from nmap or sslyze
#	Goal: Try to keep it within 200 lines
#
###

# echo "$# parameters"  # Troubleshooting
# echo "$@"		# Troubleshooting

count=0
ip=$1
port=$2
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

function check_counter () {
#	if [ $count -gt 0 ]
#	then
		echo "[*] Previous task complete!"; echo ""
		echo "[*] Return to main menu? [y/n]"; read yn; case $yn in
		[yY] | [yY][Ee][Ss] )
			echo "[!] Back to main menu in 5..."; sleep 0.5;echo "[!] 4.."; sleep 0.5;echo "[!] 3.."; sleep 0.5;echo "[!] 2.."; sleep 0.5;echo "[!] 1.."; sleep 0.5;
			;;
		[nN] | [n|N][O|o] )
			echo "[*] Exiting"; echo ""; exit
			;;
		*)
			echo "[^_^] I do not understand. To the main menu we go!"; sleep 2
		esac
		clear
#	else
#		count=`expr $count + 1`
#	fi
}

function main () {
banner
echo ""; echo "[*] -= SSLChecks.sh Main Menu =-"
echo "[*] Please select an SSL check to be performed"
echo "[*] Current Target: [$ip:$port]"
echo ""; echo "[!] NOTE: This script is still in development!"
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
echo "----F) Check for SSL/TLS support"
echo "----X) Check Certificate Expiry"
echo "----Q) Quit"
read sslcheck
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
			certificate_basic $1 $2
			;;
		6)
			weak_hashing $1 $2
			;;
		7)
			ciphers_full $1 $2
			;;
		8)
			ciphers_insecure  $1 $2
			;;
		9)
			echo "[#] No option 9 available...Yet! What would you like to see here?"
			echo "[#] Join in on the development here: https://github.com/routeback/bashscripts/blob/master/sslchecks.sh"
			;;
		[qQ])
			echo "[*] Exiting"; exit $?
			;; # Also listten for keystroke Ctrl+C break
		[cC])
			setnewtarget
			;;
		[fF])
			supports_ssl $1 $2
			;;
		[xX])
			certificate_expiry $1 $2
			;;
		*)
			echo ""; echo "[!] Invalid Option"; sleep 1.5; main
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

	        *) echo "Invalid input"
        	        ;;
		esac
	else
		main
	fi
}

function setnewtarget () {
	echo "[*] Setting new target"
	echo "[!] Please enter an IP or hostname"; read ip
        echo "[!] Please enter a port"; read port
	main
}

### SSL/TLS Check functions below ###

function supports_ssl () {
	# Perform a check if the server supports SSL/TLS connections or not.
	# If it does not, provide the option to change targets (setnewtarget)
	# If targets are unchanged, provide the option to continue with the check anyway (force) or goto main menu
	echo "[*] Checking for SSL/TLS support..."; echo ""
	ssl_connect="openssl s_client -connect $ip:$port 2> /dev/stdout" # ALT: curl --ssl-reqd -s -S https://$ip:$port | grep couldn't
	timer="timeout 3s"
	refused="$ssl | grep -q \"refused\""
	accepted="$ssl | grep -i \"SSL handshake\""

	echo "CURRENT EXIT CODE IS:" $? # Troubleshooting
	echo "CHECKING SSL/TLS SUPPORT" # Troubleshooting

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
echo "[*] Would you like to set a new target? [y/n]"; read yn; case $yn in
	[yY] | [yY][Ee][Ss] )
		setnewtarget
		;;
	[nN] | [n|N][O|o] )
		echo "[*] Target unchanged. Force SSL Check or return to Main Menu?"
		echo "---[F]orce / [M]ain / [Q]uit"; read choice; case $choice in
			[fF])
				echo "[*] FORCE: Proceeding with SSL check"
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
		echo "[*] I don't understand!" # What happens after this? 
		;;
	esac
}

# Menu option #1
function sslreneg () {
clear
echo ""; echo "[*] -= SSL Renegotiation Checker =-"
supports_ssl
( set -x; sslyze --reneg $ip:$port | tee $ip.$port.sslyze )
echo "[*] Saved as $ip.sslyze"
check_counter
}

# Menu option #2
function nmap_poodle () {
clear
echo "[*] -= Nmap SSL POODLE Scanner =-"
supports_ssl
( set -x; nmap -Pn -p $port -sV --script=ssl-poodle.nse $ip -oN $ip.nmap_poodle )
echo ""; echo "[*] Saved as $ip.nmap_poodle"
# Add checking for ssl-poodle script | while grep nmap if stderr throws nscript not found, goto ssl-poodle.nse_missing ()
# You do not have ssl-poodle.nse in your /usr/share/nmap/scripts folder. (Would you like to) Download it with
# wget -o ssl-poodle.nse <address>, then cp ssl-poodle.nse /usr/share/nmap/scripts; nmap --update-db # Then return to main
check_counter
}

# Menu option #3
function logjam () {
clear
echo ""; echo "[*] -= SSL/TLS LogJam Check =-"
supports_ssl
( set -x; openssl s_client -connect $ip:$port -cipher "EXP" | tee $ip.logjam )
echo ""; echo "[*] Saved as $ip.logjam"
check_counter
}

# Menu option #4
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

# Menu option #7
function ciphers () {
supports_ssl
# ( set -x; )
check_counter
}

# Menu option #8
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
