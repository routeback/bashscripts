#!/bin/bash
#
# Name: domain_automation.sh
# Auth: Frank Cass
# Date: 20180814
# Desc: Quickly setup a Let's Encrypt certificate for a domain and subdomain using certbot and append the configuration to King-Phisher.
#
###

if [ -z "$1" ]; then
echo "[*] LetsEncrypt HTTPS Certificate Setup Automation Script"
echo "[*] Usage: $0 <domain.com> "
exit 0
fi

echo "[*] $0 - Certificate Setup Automation Script"
echo "[!] You chose the domain: " $1
read -p "[?] Would you like to create a folder in /var/www/html/? [Y/N]: " yn
case $yn in
	[yY] | [yY][Ee][Ss] )
		echo "[*] Okay, creating webroot folder"
		mkdir /var/www/html/$1
		echo "[*] Attempting to setup certificate for domain $1..."; echo ""
		certbot certonly --webroot --webroot-path /var/www/html/$1 -d $1
		;;
	[nN] | [n|N][O|o] )
		echo "[*] Okay, moving on."
		;;
	*)
		echo "[*] I do not understand."
		exit 0
		;;
	esac

read -p "[?] Would you like to create a folder for any subdomains [Y/N]: " yn
case $yn in
        [yY] | [yY][Ee][Ss] )
                read -p "[*] Okay, what subdomain? Only specify the prefix (eg. mail/raffle/secure): " sub
                mkdir /var/www/html/$sub.$1
		echo "[*] Attempting to setup certificate for subdomain: " $sub.$1; echo ""
		certbot certonly --webroot --webroot-path /var/www/html/$sub.$1 -d $sub.$1
                ;;
        [nN] | [n|N][O|o] )
                echo "[*] Okay, moving on."
                ;;
        *)
                echo "[*] I do not understand."
                exit 0
                ;;
        esac

read -p "[?] Any additional subdomains [Y/N]: " yn
case $yn in
	[yY] | [yY][Ee][Ss] )
                read -p "[*] Okay, what subdomain? Only specify the prefix (eg. mail/raffle/secure): " sub
                mkdir /var/www/html/$sub.$1
		echo "[*] Attempting to setup certificate for subdomain: " $sub.$1; echo ""
                certbot certonly --webroot --webroot-path /var/www/html/$sub.$1 -d $sub.$1
		;;
        [nN] | [n|N][O|o] )
                echo "[*] Okay, moving on."
                ;;
        *)
                echo "[*] I do not understand."
                exit 0
                ;;
        esac

echo "[*] Manually append these certificate paths to the King-Phisher configuration file /opt/king-phisher/server_config.yml"
echo ""
echo "   - host: $1.com" 					# >> /opt/king-phisher/server_config.yml
echo "     ssl_cert: /etc/letsencrypt/live/$1/cert.pem" 	# >> /opt/king-phisher/server_config.yml
echo "     ssl_key: /etc/letsencrypt/live/$1/privkey.pem" 	# >> /opt/king-phisher/server_config.yml

if [ -z "$sub" ]
  then
	echo ""
  else
        echo "   - host: $sub.$1.com"                                   # >> /opt/king-phisher/server_config.yml
        echo "     ssl_cert: /etc/letsencrypt/live/$sub.$1/cert.pem"    # >> /opt/king-phisher/server_config.yml
        echo "     ssl_key: /etc/letsencrypt/live/$sub.$1/privkey.pem"  # >> /opt/king-phisher/server_config.yml
	echo ""
  fi

echo "[!] King-Phisher must be restarted! You must perform this manually: "
echo "[*] Command: service king-phisher restart"
echo "[*] Afterwards, your website should now be live. You can begin creating your landing page."

# Work In Progress (WIP) Below:
	# Pretext development automation, copy and paste templatized pretexts.
	# Would you like to modify an existing OWA portal login? sed -i '/company confidential/' *
