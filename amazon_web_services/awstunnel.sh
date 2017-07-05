#!/bin/bash
#
# Name: awstunnel.sh
# Auth: Frank Cass
# Date: 20170613
# Desc: This command will discover the IP of an EC2 instance using the Amazon AWS CLI and then connect to it via a backgrounded, dynamic port forwarded SSH connection.
# 	This allows for a quick SSH tunnel with port 9050 to be forwarded and act as a SOCKS proxy
#	This is useful for when wanting to proxy traffic from your browser through Burp Suite and out through an EC2 instance
#	This script assumes your EC2 instance is already started and running.
# 	This script assumes you do not use elastic IP and have a new IP assigned each time you restart the instance
#	This script will attempt to identify that IP before establishing an SSH connection
#	User will need to specify the key they intend to use if multiple keys are found within the directory
#	SSH command uses ubuntu username for logon, assuming Ubuntu linux AMI. This will need to be changed manually if needed.
#	If you are sure the IP and keyfile is correct, but still cannot establish an SSH connection, ensure that your EC2 instance and the associated security group allow inbound connections on port 22 from your public IP address
#	You can check your security group settings with: aws ec2 describe-security-groups
#	You can update the inbound security group rules with: manualupdate.sh
#
# 	Usage - Must be run in folder where AWS keys are stored. Must have one or more EC2 instances already started.
# 	If no IPs were found or no instance IDs were found to be in the running state, then check instances with: aws ec2 describe-instance-status
# 	Requires AWS cli to be setup already, refer to: https://aws.amazon.com/cli/
#
#	Logs to local directory as awstunnel.log with timestamp and PID information.
#
###

function banner () {
        clear
        echo "Amazon Web Services - Automatic EC2 SSH Tunnel"; echo ""
	}

banner # Call banner function, clear screen and print title message

function discover_aws_ip () { # Discover IP of AWS EC2 Instance using AWS CLI and IP regular expressions
	echo "[*] Discovering AWS EC2 IP..."
	# Currently only accounts for a single IP address, has not been tested if multiple IPs are returned
	ip=$(aws ec2 describe-instances | grep PublicIpAddress | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
	# Check if an IP was returned from aws cli, if not, then
	# if [ ip = "" ]; then
	#	echo "[*] Check EC2 Status: aws ec2 describe-instances"
	# 	echo "[*] Start EC2 Instance: aws ec2 start-instances --instance-ids <ID Number>
	#	exit 0
	# else
	# fi
	echo "[*] EC2 IP Found: $ip"
	}

function sshconnect() { # Establish background SSH connection with dynamic port forwarding
	echo "[*] Establishing SSH tunnel..."; sleep 1; echo ""
	# Output command to terminal with a subshell ( set -x ; )
	# SSH params: IPv4 Only, use $key, compression enabled, dynamic port forward on 9050, send to background, no commands to be executed, verbose output, connect to ubuntu@ec2serverip
	( set -x; ssh -4 -i $key -C -D9050 -f -N -v ubuntu@$ip )
	}

if [ $(ls | grep .pem | wc -l) -eq "0" ]; then # Check for any keys in the current folder
	echo "[!] No keys found."
	echo "[!] Ensure that you are running this script from within the folder where your EC2 .pem keys are stored."
	exit 0
	fi

if [ $(ls | grep .pem | wc -l) -eq "1" ]; then # If only one key is found, use it
	key=$(ls | grep .pem)
	echo "[*] Single key found: $key."
	discover_aws_ip
	sshconnect
	fi

if [ $(ls | grep .pem | wc -l) -gt "1" ]; then # If multiple keys are found, let the user choose one
	echo "[!] Multiple keys found."
	echo "[*] Which key would you like to use?"; echo ""
	PS3="[*] Selection: "
	select FILENAME in *.pem;
	do
	  case $FILENAME in
        	"$Keylist")
	          echo "Exiting."
	          break
	          ;;
	        *)
	          key="$FILENAME"
		  echo "[*] $key chosen."
		  break
	          ;;
	  esac
	done
	discover_aws_ip
	sshconnect
fi

echo "[*] Tunnel Established. Process ID of SSH Connection is: $!"
echo "[*] Tunnel started at `date`. PID: $!" >> awstunnel.log
echo "[*] Remember to use proxychains for command line operations!"
echo "[*] Press Enter to return to shell."; read -p "" return
