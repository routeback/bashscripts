# References File: Bash Scripting
# Desc: Reference of commonly used bash scripting techniques

# For loop

for i in $(cat ip); do host $ip; done

# Source Scripting

#!/bin/sh -i 

# Executing script with parameters

if [ -z "$1" ]; then
echo "[*] Name of script"
echo "[*] Usage : $0 <Parameter> "
exit 0
fi

# Saving to a file with multiple lines using End Of Field (EOF)

echo "[*] Using EOF to save files with multiple lines of input"
echo "$ cat << EOF > lots_of_text.txt"
echo "$ This would be line 1"
echo "$ This would be line 2"
echo "$ And this is the end"
echo "$ EOF"

# Troubleshooting / Screenshotting of commands executed

( set -x; <SCRIPT> ) 	# Echo on to show commands used within a subshell
( set +x; ) 		# Echo off 

### WIP ###

# How to Exit if not passed std in?
# While loop
# True / false
# Setting variables
# Using operators && ||
# Threading
# Background jobs
# Daemons

