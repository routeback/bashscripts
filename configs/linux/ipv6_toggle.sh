#!/bin/bash

echo "[*] IPv6 Support Toggler"
nano /etc/sysctl.conf
#disable ipv6 = 1, Enable = 0 
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.eth0.disable_ipv6 = 0

# Enable new settings
sysctl -p

$ cat /proc/sys/net/ipv6/conf/all/disable_ipv6

sysctl net.ipv6.conf.all.disable_ipv6=0
sysctl net.ipv6.conf.all.disable_ipv6=1
