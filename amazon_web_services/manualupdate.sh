#!/bin/bash
#
# Name: secgroup_update.sh
# Auth: Frank Cass
# Date: 20190326
# Desc: Quickly update your EC2 securitygroup with your public IP address to allow for SSH access
#
###

clear
echo "[*] Amazon AWS Security Group Ingress Port Updater"
read -p "[*] Enter a port you would like to whitelist: " port
checkpublic=$(pub=$(curl -s ifconfig.co); echo "$pub" | awk '{ print $0 "/32" }')
read -p "[*] Enter the name of the security group for updating: " group
echo "[*] Your public IP is: $checkpublic"
read -p "[*] Enter public IP to be added to the security group (xxx.xxx.xxx.xxx/32): " ip
( set -x; aws ec2 authorize-security-group-ingress --group-name $group --protocol tcp --port $port --cidr $ip )
echo "[*] Done."




