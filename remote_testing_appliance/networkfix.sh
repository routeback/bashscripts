#!/bin/bash
#
# NAME: networkfix.sh
# AUTH: Frank Cass
# DATE: 20180101
# DESC: When nothing else works, sometimes you have to try everything.
#
# WARNING: Do not run this on a remote appliance unless you have physical access to reset it! I am not responsible if you are unable to reconnect to a device after running this script.
#
###

	echo "[*] Let's fix that network!"

# Add a line which displays available interfaces
	read -p "[*] Provide an interface name (Ex. eth0): " iface

# Display commands, revoke DHCP lease, stop Network Manager, take down the interface.
	echo ""; set -x
	dhclient -v -r $iface # pgrep dhclient | xargs kill -9 # An alternative force option, if necessary
	service network-manager stop
	ifconfig $iface down
	set +x

# Manually Configure DNS Servers
# This is a not-so-smart way of adding nameservers to these files.
#	echo "dns-nameserver 8.8.8.8" >> /etc/network/interfaces
#	echo "dns-nameserver 4.4.2.2" >> /etc/network/interfaces
#	echo "dns-nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/base
#	echo "dns-nameserver 4.4.2.2" >> /etc/resolvconf/resolv.conf.d/base

# Force "fix" resolv.conf
	echo ""; echo "[*] Re-creating /etc/resolv.conf."
	chattr -i /etc/resolv.conf
	rm /etc/resolv.conf # Remove current resolv.conf file
	touch /etc/resolv.conf
	echo "nameserver 8.8.8.8" >> /etc/resolv.conf
        echo "nameserver 4.4.2.2" >> /etc/resolv.conf
# 	chattr +i /etc/resolv.conf
	echo "[*] Reviewing permissions for /etc/resolv.conf: "; ls -laH /etc/resolv.conf

# rm /etc/resolvconf/run
# mkdir /etc/resolvconf/run

# Bring the interfaces and network manager back up, request DHCP lease
	echo ""; echo "[*] Bringing the interface back up."; echo ""
	ifconfig $iface up
	service network-manager start
	dhclient -1 -v $iface
	set +x

# To configure a static IP:
	# read -p "[*] Enter static IP: " ip
	# read -p "[*] Enter a netmask: " mask
	# ifconfig $iface $ip netmask $mask

# What does this do? ifconfig $iface broadcast <sed magic ip .255>

# Print out networking information

	echo ""; echo "[*] Printing adapter information"; nmcli connection show; echo ""; nmcli dev show | grep -v IP6
	echo ""; echo "[*] Printing interface information"; ifconfig $iface
	echo "[*] Printing route information"; route -n
	echo ""; read -p "[*] Press Enter to reconfigure resolv.conf or Ctrl+C to quit: " enter
	chattr -i /etc/resolv.conf
	dpkg-reconfigure resolvconf
	# Capture the CTRL+C, if pressed, then say
	# echo; echo "[*] Network interface $iface is "fixed". Try to ping now."


# Additional Tests:
# ln -s /run/resolvconf/resolv.conf
# service resolvconf restart
# systemctl enable resolvconf
# apt-get install --reinstall resolvconf

# Refuse DHCP DNS Servers
# echo "supersede domain-name-servers 8.8.8.8, 4.4.2.2;" >> /etc/dhcp/dhclient.conf
# Also you can comment out in /etc/dhcp/dhclient.conf in request parameters that you don't want to request, for DNS it can be domain-name, domain-name-servers, domain-search
