#!/bin/sh
service postgresql start
service metasploit start
msfdb init
msfconsole
db_status
db_rebuild_cache

