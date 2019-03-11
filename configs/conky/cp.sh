#!/bin/bash
# Creates the conky config directory, copies this config locally and sets conky to run on startup during interactive sessions.

echo "[*] Creating ~/.config/conky directory."
mkdir -p ~/.config/conky
echo "[*] Copying conky.conf to ~/.config/conky/"
cp conky.conf ~/.config/conky/
echo "[*] Creating startup script in /etc/profile.d/"
echo "conky -p 10 -c ~/.config/conky/conky.conf" >> /etc/profile.d/conky.sh
echo "[*] Done"
