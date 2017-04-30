#!/bin/sh
service postgresql start
service metasploit start
msfdb init
msfdb start
msfconsole
db_status
db_rebuild_cache
