#!/bin/bash

echo "[*] IPv6 Support Toggler"
echo "[*] Edit the following file: /etc/sysctl.conf"
echo "[*] Change the following lines as necessary."
echo "[*] Disable ipv6 = 1"
echo "[*] Enable ipv6 = 0"

echo "`cat <<EOF

net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.eth0.disable_ipv6 = 0
EOF`"
echo ""
echo "[*] Then enable new settings with: sysctl -p"
echo "[*] Verify with: cat /proc/sys/net/ipv6/conf/all/disable_ipv6"
echo "`cat <<EOF

[*] Alternative method to enable/disable:

sysctl net.ipv6.conf.all.disable_ipv6=0
sysctl net.ipv6.conf.all.disable_ipv6=1
EOF`"
