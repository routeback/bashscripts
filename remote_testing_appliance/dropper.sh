
#!/bin/sh
#
# Name: dropper.sh
# Auth: Frank Cass
# Date: 20170514
# Desc: Quick installation script for pentest tools
#
#	TODO: Implement Quiet git clone and wget
#	TODO: Setup bashrc, including alias / export, $PATH - Currently separate reference scripts
#	TODO: Prompt for input of other config files (read input for terminator config, ~/.ssh/config, /etc/hosts)
#	TODO: Combine with welcome screen / aesthestics config scripts
#	TODO: Implement feature to navigate to the $install directory and then perform a git pull to update all the tools and to prevent re-cloning of existing ones
#
###

echo "[*] Dropper: A quick installation script for common pentest tools and resources."; sleep 1

### Requirements Check ###
which wget &>/dev/null
if [[ $? -ne 0 ]]; then
    echo "[!] wget needs to be installed to run this script"
    exit 1
fi
which git &>/dev/null
if [[ $? -ne 0 ]]; then
    echo "[!] git needs to be installed to run this script"
    exit 1
fi

read -p "[*] Where to install tools to? [Ex. /root/scripts]: " install
mkdir -p $install; cd $install

### TOOLS ###
echo ""; echo "[*] Installing bashscripts"
git clone https://github.com/routeback/bashscripts.git

echo ""; echo "[*] Installing Responder"
git clone https://github.com/lgandx/Responder.git

echo ""; echo "[*] Installing CredCrack"
git clone https://github.com/gojhonny/CredCrack.git

echo ""; echo "[*] Installing InSpy"
git clone https://github.com/gojhonny/InSpy.git

echo ""; echo "[*] Installing Raven"
git clone https://github.com/0x09AL/raven.git

echo ""; echo "[*] Installing PwnPaste"
git clone https://github.com/gojhonny/pwnpaste.git

echo ""; echo "[*] Installing Blacksheepwall"
git clone https://github.com/tomsteele/blacksheepwall.git

echo ""; echo "[*] Installing Powershell Empire"
git clone https://github.com/PowerShellEmpire/Empire.git

echo ""; echo "[*] Installing Snarf SMB MitM"
git clone https://github.com/purpleteam/snarf

echo ""; echo "[*] Installing EyeWitness"
git clone https://github.com/ChrisTruncer/EyeWitness

echo ""; echo "[*] Installing DNSRecon"
git clone https://github.com/darkoperator/dnsrecon

echo ""; echo "[*] Installing RIDEnum"
git clone https://github.com/trustedsec/ridenum.git

echo ""; echo "[*] Installing IkeForce"
git clone https://github.com/SpiderLabs/ikeforce.git

echo ""; echo "[*] Installing SSLyze"
git clone https://github.com/iSECPartners/sslyze.git

echo ""; echo "[*] Installing SSLScan"
git clone https://github.com/rbsec/sslscan.git

echo ""; echo "[*] Installing Nikto"
git clone https://github.com/sullo/nikto.git

echo ""; echo "[*] Installing Impacket"
git clone https://github.com/CoreSecurity/impacket.git

echo ""; echo "[*] Installing Parsero"
git clone https://github.com/behindthefirewalls/Parsero.git

echo ""; echo "[*] Installing iPwn Scripts"
git clone https://github.com/altjx/ipwn

echo ""; echo "[*] Installing rdp-sec-check"
git clone https://github.com/portcullislabs/rdp-sec-check.git
echo ""; echo "[*] Installing dependencies for rdp-sec-check, this may take a few moments"
perl -MCPAN -e "install Convert::BER" > /dev/null
cpan install Encoding::BER > /dev/null

echo ""; echo "[*] Installing Lynis System Auditor"
git clone https://github.com/CISOfy/lynis.git

echo ""; echo "[*] Installing CrackMapExec"
git clone https://github.com/byt3bl33d3r/CrackMapExec.git

echo ""; echo "[*] Installing Etherleak"
# To use, run ether leak while pinging a target with hping3 -1 -d 0 1 <IP>
wget -O etherleak.pl https://www.exploit-db.com/download/3555

echo ""; echo "[*] Installing Javaws"
# Installs the javaws tool for opening launch.jnlp files
apt-get -y install icedtea-netx

echo ""; echo "[*] Installing SMBExec"
git clone https://github.com/brav0hax/smbexec.git

echo ""; echo "[*] Installing WhatWeb"
git clone https://github.com/urbanadventurer/WhatWeb.git

echo ""; echo "[*] Installing WinShock (MS14_066) Check"
git clone https://github.com/anexia-it/winshock-test.git

echo ""; echo "[*] Installing AD-LDAP-Enum"
git clone https://github.com/CroweCybersecurity/ad-ldap-enum

echo ""; echo "[*] Installing Phishery"
git clone https://github.com/ryhanson/phishery

echo ""; echo "[*] Installing Mimikatz"
git clone https://github.com/gentilkiwi/mimikatz

echo ""; echo "[*] Installing Deathstar"
git clone https://github.com/byt3bl33d3r/DeathStar

echo ""; echo "[*] Installing Redsnarf"
git clone https://github.com/nccgroup/redsnarf

echo ""; echo "[*] Installing Decept Proxy"
git clone https://github.com/Cisco-Talos/Decept

### NMAP SCRIPTS ###
echo ""; echo "[*] Installing nmap script: vmware-fingerprint.nse"
git clone https://gist.github.com/10695801.git; mv 10695801/vmware-fingerprint.nse /usr/share/nmap/scripts; rm -r 10695801

echo ""; echo "[*] Installing nmap script: ms15-034.nse"
wget -O /usr/share/nmap/scripts/ms15-034.nse https://raw.githubusercontent.com/pr4jwal/quick-scripts/master/ms15-034.nse

echo ""; echo "[*] Updating nmap script database"; nmap --script-updatedb > /dev/null

### PAYLOADS && RESOURCES ###
echo ""; echo "[*] Grabbing Web Payloads"
git clone https://github.com/foospidy/payloads.git

echo ""; echo "[*] Installing Veil Framework"
git clone https://github.com/Veil-Framework/Veil
cd Veil; ./Install.sh -c; echo "[*] Veil Setup Complete"

echo ""; echo "[*] Installing SecLists"
git clone https://github.com/danielmiessler/SecLists

echo ""; echo "[*] Installing Awesome Fuzzing"
git clone https://github.com/secfigo/Awesome-Fuzzing

echo ""; echo "[*] Installing Awesome Hacking"
git clone https://github.com/Hack-with-Github/Awesome-Hacking

echo ""; echo "[*] Installing Pentest Cheatsheet"
git clone https://github.com/coreb1t/awesome-pentest-cheat-sheets

### Tar it all up ###
echo ""; echo "[*] Downloads complete. Navigate to $install to find them."; echo ""
read -p "[!] Would you like to create a .tar archive of $install for easy copying to a remote testing appliance? [Y/N]: " totarornottotar

output=$install/dropper.tar

case $totarornottotar in
	[yY] | [yY][Ee][Ss] )
       	       	echo "[*] Creating tar archive.";
		tar -cf dropper.tar --exclude dropper.tar -P $install;
		echo "[*] Tar size is: `du -h --max-depth 1` $output";
		echo "[*] SHA256 Sum: `sha256sum $output`";
		echo "[*] Exiting.";
               	;;

	[nN] | [n|N][O|o] )
       	        echo "[*] Exiting.";
	        ;;

	*)
		echo "[*] Invalid Option!"
        	echo "[*] Exiting.";
		;;
esac
