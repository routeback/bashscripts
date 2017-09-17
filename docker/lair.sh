#!/bin/sh
#
# Name: lair.sh
# Auth: Frank Cass
# Date: 20170917
# Desc: Starts up the lair docker container pulled from Docker Hub.
# Reference: https://hub.docker.com/r/routeback/starboard/tags/
#
# Usage:
# 	$ docker pull routeback/starboard:lair-backup
#	$ docker images
#	$ docker tag <imageID> lair-backup:lair
#	$ mkdir -p ~/docker/lairdata
#	$ lair.sh
#
###

docker run -d -it -v ~/docker/lairdata:/root/lairdata -p 11013:11013 lair-backup:lair /bin/bash -c "cd /root/lair; ./lairstart.sh"

# -d daemon
# -it interactive
# -p 11013:11013 port forward
# -v attached data volume for persistence
