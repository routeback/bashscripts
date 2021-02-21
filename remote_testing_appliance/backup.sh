#!/bin/sh
#
# Name: backup.sh
# Auth: Frank Cass
# Date: 20210220
# Desc: Automate remote incremental backups with rsync, ssh and cron.
# 
###

# Note: Currently only intended to be run once to automate the backup process, then backup_files.txt can be edited for including new incremental backups.
# Could be improved by creating parameter based input instead of interactive prompting and reading of STDIN.

echo "[*] $0; sleep 1
read -p "[*] Enter username for remote backup: " user
read -p "[*] Enter IP or hostname for remote backup: " remote

# Add your remote backup host to the ssh config
echo "Host remote_backup" >> ~/.ssh/config
echo "HostName $remote" >> ~/.ssh/config
echo "User $user" >> ~/.ssh/config

# Generate an RSA key
ssh-keygen -t rsa -b 2048

# Upload your RSA public key
sftp remote_backup
mkdir .ssh
cd .ssh/
put -p /home/$user/.ssh/id_rsa.pub authorized_keys # Not tested if variable will be passed through SFTP.
cd ..
mkdir backups
exit

# Create the backup script
mkdir -p ~/scripts
touch ~/scripts/autobackup.sh
chmod u+x ~/scripts/autobackup.sh

# Create the backup_files.txt list
touch ~/scripts/backup_files.txt

echo "SUFFIX=$(date +%j) # Prints current day of year in 001-365 format." >> ~/scripts/autobackup.sh
rsync -ab --recursive --files-from='~/scripts/backup_files.txt' --backup-dir=backup_$SUFFIX --delete --exclude=backup --filter='protect backup_*' /home/$user/ remote_backup:backups/
