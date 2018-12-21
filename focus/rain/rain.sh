#!/bin/bash
#
# Name: rain.sh
# Auth: Frank Cass
# Date: 20180418
# Desc: Relax with rain sounds from the command line.
#
# TODO: Implement a y/n of: Would you like to open pomodoro timer too?
# 	Check if it's installed, if not, would you like to install
# 	Ex. sudo apt install pomodoro
#
# TODO: Implement a check for wget and mpv REQs mpv/wget
# TODO: Implement a check for sounds folder first, if it exists and contains .ogg, autoplay?
# BUG - First time running it and downloading the sounds will fail playback, it's not until the second execution when you respond with no to the download question that it will play.
# 	Is this because it needs a short sleep timer before the check function?
# BUG - If no internet connection for WGET, it will very quickly fail without explaining why.
# BUG - The Sound device is not connected to kali / vmware upon reboot, and must be done manually every time.
# SOLUTION - Check if the script is ran in a VM first, and if there are any sound devices connected, if not, prompt the user to connect it.
#
###

cd /root/scripts/bashscripts/focus/rain/ # doesn't seem to CD to this directory for some reason

which mpv &>/dev/null
if [[ $? -ne 0 ]]; then
    echo "[!] mpv needs to be installed to run this script."
    echo "[!] Try 'sudo apt install -y mpv'"
    exit 1
fi

download() {
	# Prompt the user to download rain sounds if they do not have them already.
	read -p "[*] Would you like to download rain sounds from Rainymood.com? [y/n]: " yn; case $yn in
	[yY] | [yY][Ee][Ss] )
		echo "[*] Looks like it might rain afterall..."; echo ""
		mkdir sounds 2> /dev/null
		cd sounds
		# Links last valid 02/27/2018
		wget --show-progress --quiet -c http://rainymood.com/audio1110/0.ogg
		wget --show-progress --quiet -c http://rainymood.com/audio1110/1.ogg
		wget --show-progress --quiet -c http://rainymood.com/audio1110/2.ogg
		;;

	[nN] | [n|N][O|o] )
		;;

	*)
		echo "[*] I do not understand."
		exit 1
		;;
	esac
	}

check() {
	# If .ogg sound filetype exists, then continue, else fail
	soundcheck="$(find -type f -name "*.ogg" | head -n 1)"
	if [[ -e $soundcheck ]] #= true ]]
	then
		return 0
		break
	else [[ -e $soundcheck ]] #= false ]]
		echo "[*] I don't think it's going to rain..."
		exit 1
	fi
	}

ascii() {
	# Print out base64 encoded ASCII art and the figlet output 'rain'
	# Example saved as 'ascii.art'
	cat > .art << EOF;
H4sIAMIglloAA72O0Q3DIAwFv8kUb4BI9kBIHqELePgGJY5T10ZKW9VIYODuQUNVKyScLNa0yJISOiAr8Ijwu6QiBIJu3TA1gV1SdKFOKuMN3VxyuJXeKOZ9sZ3tmSeaYTbzcbA3tXiAl5lPfabyCwuXL0GFbJf+TNblPt+tmHA7IEZ8EJB8w4vmoxL/Jf1OyPDvUMeWJ0hwzCAPBAAA
EOF
	base64 -d .art 2> /dev/null | gunzip
	}

play() {
	# Randomly select a rain sound file and begin playing it
	rain=$((RANDOM%3))
	mpv sounds/$rain.ogg --volume=100 --really-quiet
	}

### Calling all functions ###

clear
download
clear
check
ascii
play

### Exit from .ogg reaching the end of playback from mpv or from a break command being issued ###

echo "[*] Looks like it stopped raining..."
