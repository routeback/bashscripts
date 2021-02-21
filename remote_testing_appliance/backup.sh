#!/bin/sh
#
# Name: backup.sh
# Auth: Frank Cass
# Date: 20210220
# Desc: Automate remote incremental backups with rsync, ssh and cron.
# 
# Reference: https://www.jveweb.net/en/archives/2011/02/using-rsync-and-cron-to-automate-incremental-backups.html
#
###

# Note: Currently only intended to be run once to automate the backup process, then backup_files.txt can be edited for including new incremental backups.
# Note: Script could be improved by opting for parameter based input instead of interactive prompting and reading of STDIN, would allow for greater automation and script wrapping.

# Check for rsync, sftp, ssh, cron
which rsync &>/dev/null
if [[ $? -ne 0 ]]; then
    echo "[!] rsync needs to be installed to run this script."
    exit 1
fi

which sftp &>/dev/null
if [[ $? -ne 0 ]]; then
    echo "[!] sftp needs to be installed to run this script."
    exit 1
fi

which ssh &>/dev/null
if [[ $? -ne 0 ]]; then
    echo "[!] ssh needs to be installed to run this script."
    exit 1
fi

which cron &>/dev/null
if [[ $? -ne 0 ]]; then
    echo "[!] cron needs to be installed to run this script."
    exit 1
fi

# Add tar | gzip logic for compressed backups

echo "[*] $0; sleep 1
read -p "[*] Enter username for remote backup: " user
read -p "[*] Enter IP or hostname for remote backup: " remote

# Add your remote backup host to the ssh config
echo "[*] Adding remote_backup host to local SSH config."
echo "Host remote_backup" >> ~/.ssh/config
echo "HostName $remote" >> ~/.ssh/config
echo "User $user" >> ~/.ssh/config

# Generate an RSA key
echo "[*] Generating an RSA key."
ssh-keygen -t rsa -b 2048

# Upload your RSA public key
echo "[*] Uploading public RSA key using SFTP."
sftp remote_backup
mkdir .ssh
cd .ssh/
put -p /home/$user/.ssh/id_rsa.pub authorized_keys # Not tested if variable will be passed through SFTP.
cd ..
mkdir backups
exit

# Create the backup script
echo "[*] Creating the backup script folder and autobackup script for cron (~/scripts/autobackup.sh)."
mkdir -p ~/scripts
touch ~/scripts/autobackup.sh
chmod u+x ~/scripts/autobackup.sh

# Insert backup logic into script
echo "SUFFIX=$(date +%j) >> ~/scripts/autobackup.sh
echo "# Prints current day of year in 001-365 format." >> ~/scripts/autobackup.sh
echo "rsync -ab --recursive --files-from='~/scripts/backup_files.txt' --backup-dir=backup_$SUFFIX --delete --exclude=backup --filter='protect backup_*' /home/$user/ remote_backup:backups/" >> ~/scripts/autobackup.sh

# Create the backup_files.txt list
echo "[*] Creating ~/scripts/backup_files.txt"
touch ~/scripts/backup_files.txt

# Create the cron job
echo "[*] Creating cron file (~/scripts/backup.cron) and adding to crontab."
echo "@daily /home/$user/scripts/autobackup.sh" > ~/scripts/backup.cron
crontab ~/scripts/backup.cron

echo "[*] All done! Be sure to update ~/scripts/backup_files.txt with files and folders you would like backed up."
