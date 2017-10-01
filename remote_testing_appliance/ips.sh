#!/bin/sh
#
# Name: ips.sh
# Auth: Frank Cass
# Date: 20171001
# Desc: Gathers and displays IP Addresses for a quick and easy reference, including:
#		- AWS EC2 IPs
#		- Public IP
#		- Local interfaces
###

echo "[*] Gathering EC2, Public and Local IPs..."

ec2ip=$(aws ec2 describe-instances | grep PublicIpAddress | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
interfaces=$(ifconfig | grep -v inet6 | grep -v lo | grep -o -P '.{0,20}Link' | sed 's/Link//g')

# Can be improved to describe the instance name and IP, rather than just arbitrary EC2 IPs, but for now using just Bash this is an acceptable limitation
	# Create an array storing the instance ID and public IP pairs as ```instanceID:127.0.0.1```
		# grep -i -e PublicIpAddress -e InstanceID

for i in $ec2ip; do echo "[*] EC2 IP: $ec2ip"; done
echo "[*] Your pubic IP: $(curl -s v4.ifconfig.co)"
for i in $interfaces; do echo "[*] Your IP for interface $i is:" $(ifconfig $i | grep "inet addr:" | grep -v 127.0.0.1 | sed 's/inet addr://g' | cut -d ":" -f 1 | awk '{$1=$1}{ print }' | cut -d " " -f 1); done
