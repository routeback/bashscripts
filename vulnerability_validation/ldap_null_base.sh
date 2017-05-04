#!/bin/sh
#
# Name: ldap_null_base.sh
# Auth: Frank Cass
# Date: 20160204
# Desc: Quickly perform a check for an LDAP NULL base vulnerability
#
###

echo ""; echo "		[*] ldap_null_base.sh"; echo ""
echo "[*] Enter an LDAP server Domain or IP (Ex. my.ldap.server OR 10.1.X.X)"; read server;
( set -x; ldapsearch -x -s base -b '' -H  ldap://$server "(objectClass=*)" "*" +  )
echo "[*] Done."
