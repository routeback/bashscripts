#!/bin/bash
#
# Name: secgroup_update.sh
# Auth: Frank Cass
# Date: 20170613
# Desc: Quickly update your EC2 securitygroup with your public IP address to allow for SSH access
#
###

echo "[*] $0 - Amazon AWS Security Group Ingress SSH Updater"
checkpublic=$(pub=$(curl -s ifconfig.co); echo "$pub" | awk '{ print $0 "/32" }')
echo "[*] I think your public IP is: $checkpublic - But you should double check."
read -p "[*] Enter the name of the security group for updating: " group
read -p "[*] Enter public IP to be added (xxx.xxx.xxx.xxx/32): " ip
( set -x; aws ec2 authorize-security-group-ingress --group-name $group --protocol tcp --port 22 --cidr $ip )
echo "[*] Done."




