#!/bin/bash

# Build the docker image from the Dockerfile

function buildtype () {
	echo "[*] Docker Security Onion Install Script"
	read -p "[*] Would you like a clean build [1] or or a cache build [2]: " a; case $a in
	[1] )
		docker build --no-cache -t securityonion .
		;;
	[2] )
		docker build -t securityonion .
		;;
	*)
		echo -n "[*] Invalid Option"; for i in $(seq 1 5); do echo -n "!"; sleep 0.05; done; echo ""
		;;
	esac
}

buildtype

