#!/bin/sh

echo "[*] Gathering EC2, Public and Local IPs..."

ip=$(aws ec2 describe-instances | grep PublicIpAddress | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
interfaces=$(ifconfig | grep -v inet6 | grep -v lo | grep -o -P '.{0,20}Link' | sed 's/Link//g')

echo "[*] EC2 IP: $ip"
echo "[*] Your pubic IP: $(curl -s v4.ifconfig.co)"

for i in $interfaces; do
	echo "[*] Your IP for interface $i is:" $(ifconfig $i | grep "inet addr:" | grep -v 127.0.0.1 | sed 's/inet addr://g' | cut -d ":" -f 1 | awk '{$1=$1}{ print }' | cut -d " " -f 1)

done
