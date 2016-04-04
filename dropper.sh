#!/bin/sh
#
# Name: dropper.sh
# Auth: Frank Cass
# Date: 20160413
# Desc: Quick installation script for pentest tools
#
#	TODO: Implement Quiet git clone and wget
#	TODO: Setup bashrc, including alias / export, $PATH - Currently separate reference scripts
#	TODO: Prompt for input of other config files (read input for terminator config, ~/.ssh/config, /etc/hosts)
#	TODO: Combine with welcome screen / aesthestics config scripts
#
###

echo "[*] dropper.sh"
echo "[*] Desc: Quick installation script for common pentest tools."
read -p "[*] Where to install tools to? [Ex. /root/scripts]: " install
mkdir -p $install; cd $install
echo "[*] Installing bashscripts"
git clone https://github.com/routeback/bashscripts.git
echo "[*] Installing Responder"
git clone https://github.com/SpiderLabs/Responder.git
echo "[*] Installing CredCrack"
git clone https://github.com/gojhonny/CredCrack.git
echo "[*] Installing InSpy"
wget -O InSpy.py https://raw.githubusercontent.com/gojhonny/Pentesting-Scripts/master/InSpy.py
echo "[*] Installing PwnPaste"
git clone https://github.com/gojhonny/pwnpaste.git
echo "[*] Installing Blacksheepwall"
git clone https://github.com/tomsteele/blacksheepwall.git
echo "[*] Installing Powershell Empire"
git clone https://github.com/PowerShellEmpire/Empire.git
echo "[*] Installing RIDEnum"
git clone https://github.com/trustedsec/ridenum.git
echo "[*] Installing IkeForce"
git clone https://github.com/SpiderLabs/ikeforce.git
echo "[*] Installing SSLyze"
git clone https://github.com/iSECPartners/sslyze.git
echo "[*] Installing SSLScan"
git clone https://github.com/rbsec/sslscan.git
echo "[*] Installing Nikto"
git clone https://github.com/sullo/nikto.git
echo "[*] Installing Impacket"
git clone https://github.com/CoreSecurity/impacket.git
echo "[*] Installing Parsero"
git clone https://github.com/behindthefirewalls/Parsero.git
echo "[*] Installing iPwn Scripts"
git clone https://github.com/altjx/ipwn
echo "[*] Installing rdp-sec-check"
git clone https://github.com/portcullislabs/rdp-sec-check.git
perl -MCPAN -e "install Convert::BER" > /dev/null
cpan install Encoding::BER > /dev/null
echo "[*] Installing Lynis System Auditor"
git clone https://github.com/CISOfy/lynis.git
echo "[*] Installing CrackMapExec"
git clone https://github.com/byt3bl33d3r/CrackMapExec.git
echo "[*] Installing Etherleak"
wget -O etherleak.pl https://www.exploit-db.com/download/3555
# Run ether leak, then separately hping3 -1 -d 0 1 <IP>
echo "[*] Installing Javaws"
apt-get install icedtea-netx # (javaws for launch.jnlp files, such as when connecting to BMC interfaces)
echo "[*] Installing SMBExec"
git clone https://github.com/brav0hax/smbexec.git
echo "[*] Installing Nmap script: vmware-fingerprint.nse"
git clone https://gist.github.com/10695801.git; mv 10695801/vmware-fingerprint.nse /usr/share/nmap/scripts; rm -r 10695801; nmap --script-updatedb > /dev/null
echo "[*] Installing Nmap script: ms15-034.nse"
wget -O /usr/share/nmap/scripts/ms15-034.nse https://raw.githubusercontent.com/pr4jwal/quick-scripts/master/ms15-034.nse
echo "[*] Installing Veil"
git clone https://github.com/Veil-Framework/Veil
cd Veil; ./Install.sh -c; echo "[*] Veil Setup Complete"
echo "[*] Done"
