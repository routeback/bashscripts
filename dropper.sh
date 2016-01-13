#!/bin/sh
#
# Name: dropper.sh
# Auth: Frank Cass
# Date: 20151231
# Desc: Quick installation script for pentest tools
#
#	TODO: Implement Quiet git clone and wget
#	TODO: Setup bashrc / alias / $PATH / export / Other config files (Terminator and SSH - Keys and config)
#
###

echo "[*] Where to install tools to? Ex. /home/scripts"
read install
mkdir -p $install
cd $install
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
echo "[*] Done"


