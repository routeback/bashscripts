#!/bin/sh
#
# Name: dropper.sh
# Auth: Frank Cass
# Date: 20170514
# Desc: Quick installation script for pentest tools
#
#	TODO: Find a way to quickly pick and choose software packages, brand it as the 'ninite for linux tools'
#	TODO: Implement Quiet git clone and wget
#	TODO: Setup bashrc, including alias / export, $PATH - Currently separate reference scripts
#	TODO: Prompt for input of other config files (read input for terminator config, ~/.ssh/config, /etc/hosts)
#	TODO: Combine with welcome screen / aesthestics config scripts
#	TODO: Implement feature to navigate to the $install directory and then perform a git pull to update all the tools and to prevent re-cloning of existing ones
#	TODO: Change text from 'Installing' to 'Cloning Repository'
#	TODO: Make usage of wget to be quiet everytime - Alias Curl and Wget at beginning of script to use quiet functionality?
###

echo "[*] Dropper: A quick installation script for common pentest tools and resources."; sleep 1

# Ensure that script is run as root or with sudo privileges first, exit if not

# What is the purpose of this check now that you install these as part of the apt update?

### Requirements Check ###

which wget &>/dev/null
if [[ $? -ne 0 ]]; then
    echo "[!] wget needs to be installed to run this script."
    exit 1
fi
which git &>/dev/null
if [[ $? -ne 0 ]]; then
    echo "[!] git needs to be installed to run this script."
    exit 1
fi

read -p "[*] Where to install tools to? [Ex. /root/scripts/]: " install # Instead state that "Tools will be installed to $PWD. Y/N to proceed."
mkdir -p $install; cd $install

# Prompt user if they would like to update git repositories rather than clone them:
# case yn in update and exit or git clone
# gitupdate='cd ~/scripts; for i in $(ls -lrt -d -1 $PWD/* | grep "^d" | awkspaces | cut -d " " -f 9); do cd $i; git pull; cd ../; done'
# Add logic to check if these repositories already exist.
# If so, then git pull instead

### TOOLS ###

echo ""; echo "[*] Adding IPQoS=throughput to /etc/ssh/ssh_config to resolve this issue when making git commits from VMware: https://communities.vmware.com/thread/590825"
echo "IPQoS=throughput" >> /etc/ssh/ssh_config

echo ""; echo "[*] Updating apt to disable HTTP redirects as a security precaution (https://justi.cz/security/2019/01/22/apt-rce.html)"
# This is known to break some proxies when used against security.debian.org. If that happens, people can switch their security APT source to use:
# deb http://cdn-fastly.deb.debian.org/debian-security stable/updates main
# For the stable distribution (stretch), this problem has been fixed in version 1.4.9.
apt update -o Acquire::http::AllowRedirect=false
apt upgrade -o Acquire::http::AllowRedirect=false

echo ""; echo "[*] Adding Microsoft signing key and Ubuntu repo list to apt sources." # May want to use parameters to quiet curl output and only print to stdout if an error occurs
curl -S -s -m 10 https://packages.microsoft.com/keys/microsoft.asc --output /tmp/microsoft.asc
apt-key add /tmp/microsoft.asc; rm /tmp/microsoft.asc
curl -S -s -m 10 https://packages.microsoft.com/config/ubuntu/14.04/prod.list --output /tmp/prod.list
cat /tmp/prod.list >> /etc/apt/sources.list.d/microsoft.list; rm /tmp/prod.list
echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" >> /etc/apt/sources.list.d/microsoft.list' # This may provide a duplicate or conflicting entry with the previous line

echo "[*] Replacing kali HTTP repository with HTTPS url in /etc/apt/sources.list"
sed -i 's/http:\/\/http.kali.org\/kali/https:\/\/http.kali.org\/kali/g' /etc/apt/sources.list
# Reference https://whydoesaptnotusehttps.com/

echo ""; echo "[*] Updating Kali signing key"
wget -q -O - https://archive.kali.org/archive-key.asc | apt-key add # Requires GnuPG etc., which is not installed until later

echo ""; echo "[*] Performing apt update"
apt update

echo ""; echo "[*] Attempting to fix broken packages and resolve dependency errors"
apt --fix-broken install

apt remove gnome-software
apt remove unattended-upgrades

echo ""; echo "[*] Adding apt support for HTTPS sources"
apt install -y apt-transport-https

echo ""; echo "[*] Grabbing tools from public apt repositories:"

echo ""; echo "[*] Installing Snap to obtain additional software."
apt install -y snapd

echo ""; echo "[*] Installing Insomnia REST API client"
snap install -y insomnia

echo ""; echo "[*] Installing Terminator"
apt install -y terminator

echo ""; echo "[*] Installing YeahConsole drop-down terminal"
apt install -y yeahconsole
# Usage: yeahconsole &
# Usage: <CTRL>+<ALT>+Y

echo ""; echo "[*] Installing GNUPG for adding keys" # Move this step so that it occurs before adding keys
apt install -y gnupg

echo ""; echo "[*] Installing htop (https://hisham.hm/htop/)"
apt install -y htop

echo ""; echo "[*] Installing moreutils (https://joeyh.name/code/moreutils/)"
apt install -y moreutils

echo ""; echo "[*] Instaling jq - JSON parser"
apt install -y jq

echo ""; echo "[*] Installing prips for quick subnet expansion and IP list generation (https://gitlab.com/prips/prips)"
apt install -y prips

echo ""; echo "[*] Installing gdebi for easy package installation on Debian"
apt install -y gdebi

echo ""; echo "[*] Installing gcc, make, git && wget"
apt install -y gcc make git wget

echo ""; echo "[*] Installing figlet for large text printing"
apt install -y figlet

echo ""; echo "[*] Installing Ruby-dev package for t (Twitter CLI)"
apt install -y ruby-dev
echo ""; echo "[*] Gem Installing t (https://github.com/sferik/t)"
gem install t

echo ""; echo "[*] Install additional pre-requisites (primarily for CrackMapExec)"
apt-get install -y libssl-dev libffi-dev python-dev build-essential

echo ""; echo "[*] Installing pip and pip3"
apt install -y python-pip python3-pip

echo ""; echo "[*] Install python3-winrm functionality for CrackMapExec"
apt install -y python3-winrm

echo ""; echo "[*] Installing pipenv via pip"
pip install pipenv

echo ""; echo "[*] Installing Unzip, FTP and Filezilla"
apt install -y filezilla ftp unzip

echo ""; echo "[*] Installing firejail and firetools"
apt install -y firejail firetools

echo ""; echo "[*] Installing OpenVPN & resolvconf"
apt install -y openvpn resolvconf

echo ""; echo "[*] Installing ProtonVPN Client pre-req's"
apt install -y dialog python wget

echo ""; echo "[*] Retrieving ProtonVPN CLI installation script and installing it"
wget -O protonvpn-cli.sh https://raw.githubusercontent.com/ProtonVPN/protonvpn-cli/master/protonvpn-cli.sh && chmod +x protonvpn-cli.sh && ./protonvpn-cli.sh --install
if $(test $? -ne 0)
then echo "[*] Error installing ProtonVPN CLI tool! Moving on..."
fi

echo ""; echo "[*] Installing Docker GPG key and Repository"
# Alternative Docker installation instructions
# https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/
# dpkg -i docker.deb
curl -fsSL https://download.docker.com/linux/debian/gpg --output /tmp/docker.gpg
apt-key add /tmp/docker.gpg
echo 'deb https://download.docker.com/linux/debian stretch stable' > /etc/apt/sources.list.d/docker.list
echo ""; echo "[*] Installing Docker-CE via apt"
apt update && apt install -y docker-ce
echo ""; echo "[*] Configuring Docker to run on startup"
systemctl enable /usr/lib/systemd/system/docker.service
systemctl start docker
echo "[*] Docker version: $(docker version --format '{{.Server.Version}}')"

echo ""; echo "[*] Cloning reposistories from Github..."

echo ""; echo "[*] Installing Discover"
git clone https://github.com/leebaird/discover.git
mv $install/discover /opt/discover # Test this

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

echo ""; echo "[*] Installing Metagoofil"
git clone git clone https://github.com/laramies/metagoofil/ && cd metagoofil
echo "[*] Downloading a patch to fix Metagoofil search error"
git fetch origin d24a7e32ec8cc251336c51d678479786adb078ea:refs/remotes/origin/commit
git reset --hard d24a7e32ec8cc251336c51d678479786adb078ea
cd ..

echo ""; echo "[*] Installing Radamsa fuzzer"
git clone https://gitlab.com/akihe/radamsa && cd radamsa && make && sudo make install
cd ..

echo ""; echo "[*] Installing mutiny-fuzzer"
git clone https://github.com/Cisco-Talos/mutiny-fuzzer

echo ""; echo "[*] Installing Decept Network Protocol Proxy"
git clone https://github.com/Cisco-Talos/Decept

echo ""; echo "[*] Downloading latest release of Bettercap"
mkdir bettercap; cd bettercap
wget -O bettercap_linux_amd64.zip $(curl -s https://api.github.com/repos/bettercap/bettercap/releases/latest | grep 'browser_' | cut -d\" -f4 | grep linux_amd64)
unzip bettercap_linux_amd64.zip && rm bettercap_linux_amd64.zip
echo ""; echo "[*] Downloading Bettercap caplets for mitm templates"
mv caplets default_caplets
git clone https://github.com/bettercap/caplets.git
cd ../

echo ""; echo "[*] Installing Patator"
git clone https://github.com/lanjelot/patator

echo ""; echo "[*] Installing Blacksheepwall"
git clone https://github.com/tomsteele/blacksheepwall.git

echo ""; echo "[*] Installing Powershell Empire"
git clone https://github.com/PowerShellEmpire/Empire.git

echo ""; echo "[*] Installing Powershell for Debian - Used for Obfuscated Powershell Payloads" # Test that these URLs are still valid
mkdir powershell; cd powershell
wget -O powershell_debian_amd64.deb $(curl -s https://github.com/PowerShell/PowerShell | grep -i debian | grep -v preview | grep -v Instructions | grep -v release-notes | cut -d "=" -f 2 | cut -d "\"" -f 2) # Reads main powershell page and downloads the latest stable Debian release
wget -O libicu57.deb http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu57_57.1-6ubuntu0.3_amd64.deb
dpkg -i libicu57.deb && rm libicu57.deb
dpkg -i powershell_debian_amd64.deb && rm powershell_debian_amd64.deb # Only run this if NOT failed, exit status must not = 1, currently I don't think this accomplishes what I want
cd ../
# Old setup instructions that often did not work due to weird dependency issues that were too difficult to continue troubleshooting
#wget http://archive.ubuntu.com/ubuntu/pool/main/i/icu/libicu52_52.1-3_amd64.deb && sudo dpkg -I libicu52_52.1-3_amd64.deb; rm libicu52_52.1-3_amd64.deb
#wget http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb && sudo dpkg -I libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb; rm libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb
#sudo apt-get install -y powershell

echo ""; echo "[*] Installing RIDRelay for low privilege AD Username enumeration"
git clone https://github.com/skorov/ridrelay

echo ""; echo "[*] Installing Snarf SMB MitM"
git clone https://github.com/purpleteam/snarf

echo ""; echo "[*] Installing EyeWitness"
# Opting to clone older version of repo as it used Chrome Headless which did not encounter the WebDriverErrors that seem to be common since they transitioned to firefox
# git clone https://github.com/ChrisTruncer/EyeWitness
git clone https://github.com/FortyNorthSecurity/EyeWitness/tree/b7d8a4698c13c103eb12cbbdcb6afe3246a934cf # Have not tested if git clone works here
cd setup; ./setup.sh; cd ../
# Include steps to download the Docker image and install it
# Include start.sh using the image witha volume attached

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
git clone --recursive https://github.com/byt3bl33d3r/CrackMapExec

# Fix for a commonly encountered python error, error not documented, may be resolved by now
# cp -r cme/thirdparty/ /usr/local/lib/python2.7/dist-packages/crackmapexec-4.0.1.dev0-py2.7.egg/cme/

# Following steps disabled while testing alternate bulk installation method for python tools
# cd CrackMapExec && pipenv install
# pipenv shell
# python setup.py install

# Alternate install method, last tested was out of date
# apt install -y crackmapexec

echo ""; echo "[*] Installing MITM6"
git clone https://github.com/fox-it/mitm6

echo ""; echo "[*] Installing Python RDP implementation"
git clone https://github.com/citronneur/rdpy

echo ""; echo "[*] Installing SETH RDP-MITM"
git clone https://github.com/SySS-Research/Seth

echo ""; echo "[*] Installing Coalfire Java Deserialization exploits"
git clone https://github.com/Coalfire-Research/java-deserialization-exploits

# Ysoserial manual installation
# mkdir ysoserial; cd ysoserial
# git clone https://github.com/frohoff/ysoserial
# wget -O ysoserial.jar https://jitpack.io/com/github/frohoff/ysoserial/master-SNAPSHOT/ysoserial-master-SNAPSHOT.jar
# Requires Java 1.7+ and Maven 3.x+
# mvn clean package -DskipTests
# cd ../

echo ""; echo "[*] Installing NCC Group VLAN Hopping tool, Frogger"
git clone https://github.com/nccgroup/vlan-hopping---frogger

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

echo ""; echo "[*] Installing Evil-SSDP"
git clone https://gitlab.com/initstring/evil-ssdp

### NMAP SCRIPTS ###
echo ""; echo "[*] Installing nmap script: vmware-fingerprint.nse"
git clone https://gist.github.com/10695801.git; mv 10695801/vmware-fingerprint.nse /usr/share/nmap/scripts; rm -r 10695801

echo ""; echo "[*] Installing nmap script: ms15-034.nse"
wget -O /usr/share/nmap/scripts/ms15-034.nse https://raw.githubusercontent.com/pr4jwal/quick-scripts/master/ms15-034.nse

echo ""; echo "[*] Updating nmap script database"; nmap --script-updatedb > /dev/null

### PAYLOADS && RESOURCES ###
echo ""; echo "[*] Installing Koadic Windows RAT"
git clone https://github.com/zerosum0x0/koadic

echo ""; echo "[*] Grabbing Web Payloads"
git clone https://github.com/foospidy/payloads.git

echo ""; echo "[*] Installing Veil Framework"
git clone https://github.com/Veil-Framework/Veil
cd Veil; ./Install.sh -c; echo "[*] Veil Setup Complete"

# Include a case statement if the user would like to download wordlists or not
echo ""; echo "[*] Installing SecLists"
git clone https://github.com/danielmiessler/SecLists

echo ""; echo "[*] Installing Awesome Fuzzing"
git clone https://github.com/secfigo/Awesome-Fuzzing

echo ""; echo "[*] Installing Awesome Hacking"
git clone https://github.com/Hack-with-Github/Awesome-Hacking

echo ""; echo "[*] Installing Pentest Cheatsheet"
git clone https://github.com/coreb1t/awesome-pentest-cheat-sheets

# FIREFOX CONFIGURATION

echo ""; echo "[*] Below is a list of recommended privacy enhancing plugins for Firefox:"
echo "[*]: https://addons.mozilla.org/en-US/firefox/addon/noscript/"
echo "[*]: https://addons.mozilla.org/en-US/firefox/addon/proxy-switcher-and-manager/"
echo "[*]: https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/"
echo "[*]: https://addons.mozilla.org/en-US/firefox/addon/adblock-plus/"
echo "[*]: https://addons.mozilla.org/en-US/firefox/addon/happy-bonobo-disable-webrtc/"

### Tar it all up ###
echo ""; echo "[*] Dropper Setup Complete! Navigate to $install to find downloaded tools."; echo ""
sleep 1; read -p "[!] Would you like to create a .tar archive of $install for easy copying to a remote testing appliance? [Y/N]: " totarornottotar

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

echo "[*] The following commands need to be run to complete tool setup:"
echo "pvpn -init"
echo "t authorize"
echo "[*] END DROPPER INSTALLATION AT: `date`"


#############################
https://github.com/OWASP/Amass
