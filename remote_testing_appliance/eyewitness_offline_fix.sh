#!/bin/bash

# Some clients with strict content filtering or network proxies will prevent Eyewitness from being able to obtain the CSS file, and the page will take up to one minute to timeout
# This script replaces that CSS link with localhost, so it fails immediately and fully loads the Eyewitness report

echo "[*] Replacing the CDN link with localhost in /root/scripts/EyeWitness/modules/reporting.py"
sed -i 's/https:\/\/maxcdn.bootstrapcdn.com\/bootstrap\/3.3.7\/css\/bootstrap.min.css/http:\/\/127.0.0.1/g' /root/scripts/EyeWitness/modules/reporting.py

if $(test $? -ne 0)
then
	echo "[*] Error patching Eyewitness!"
	echo "[*] Try replacing the URL manually."
fi

