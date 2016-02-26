# References File: bashrc
# Desc: Quick reference for commonly used ~/.bashrc lines

# Welcome Screen

figlet -w 280 -f /usr/share/figlet/banner.flf Welcome > ~/.shell.txt
cat ~/.shell.txt
echo "[*] Terminal Reset"
echo "[*] Date: `date`"
echo "[*] Current Directory: `pwd`"
echo ""; echo "[*] Tmux sessions:"; tmux ls; echo ""

# Aliases

alias append="source /root/scripts/routeback/github/bashscripts/append.sh"
alias myip=ifconfig | grep "inet addr:" | grep -v 127.0.0.1 | sed 's/inet addr://g' | awk '{$1=$1}{ print }'
alias nscript="ls /usr/share/nmap/scripts | grep -i "
alias pingg="ping 8.8.8.8"
alias sublime=sublime_text
alias msftools="cd /usr/share/metasploit-framework/tools/"
alias egghunter=/usr/share/metasploit-framework/tools/./egghunter.rb
alias chrome=chromium
alias httpproxy="proxychains chromium --user-data-dir /home/notroot"
alias chrome=$(/usr/bin/chromium %U --user-data-dir /home/notroot --ignore-certificate-errors --incognito)

# Export / $PATH

export PATH=$PATH:/root/scripts

