#!/bin/bash

# DESC: Adds the aliases in this folder to your bashrc file
# 	Checks for each of these files in this folder, rather than editing bashrc directly
#	Allows updating this git repo without having to compare changes between RC files

echo "[*] add.sh - Quickly add the *.rc files in this directory to your ~/.bashrc"
read -p "[*] Must be run in the same directory as the *.rc files; Press enter to continue." enter
echo ""

for i in $(ls | grep rc); do echo "if [ -f `pwd`/$i ]; then
. `pwd`/$i
fi; " | tee -a ~/.bashrc; done

echo ""
