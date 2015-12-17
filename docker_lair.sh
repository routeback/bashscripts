#!/bin/sh
#
# Name: docker_lair.sh
# Auth: Frank Cass
# Date: 20151217
# Desc: Automaitcally install docker and lair on a clean Ubuntu 14.04 64-bit with a single script as root to the /root directory
# 		May have to run dos2unix on the file before executing if pulled from pastebin
#		apt-get install -y dos2unix; dos2unix docker_lair.sh; ./docker_lair.sh
###

echo "[*] This script is in development as of 20151217 and is still being tested. Try at your own risk"

echo "[*] Must be root. Break now if not root"
sleep 5; cd /root; mkdir lair;

echo "[*] Making directory structure in /root and creating Dockerfile"
cat << EOF > Dockerfile
FROM ubuntu
RUN apt-get update
RUN apt-get -y install curl
RUN apt-get -y install wget
WORKDIR /root/lair
RUN mkdir /root/lair/db
RUN curl -o /root/lair/mongodb.tgz https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-3.0.6.tgz
RUN tar -zxvf mongodb.tgz
WORKDIR /root/lair
RUN wget https://github.com/lair-framework/lair/releases/download/v2.0.3/lair-v2.0.3-linux-amd64.tar.gz
RUN tar -zxvf lair-v2.0.3-linux-amd64.tar.gz
WORKDIR /root/lair/bundle
RUN /bin/bash -c 'curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.26.1/install.sh | bash \
	&& source /root/.bashrc \
	&& source /root/.nvm/nvm.sh \
	&& nvm install v0.10.40 \
	&& nvm use v0.10.40 \
	&& cd /root/lair/bundle/programs/server \
	&& npm install'
WORKDIR /root/lair
RUN wget https://github.com/lair-framework/api-server/releases/download/v1.1.0/api-server_linux_amd64
RUN chmod +x api-server_linux_amd64
WORKDIR /root/lair
RUN curl -o caddy.tar.gz 'http://caddyserver.com/download/build?os=linux&arch=amd64&features='
RUN tar -zxvf caddy.tar.gz
RUN openssl req -days 3650 -new -x509 -newkey rsa:2048 -nodes -keyout key.pem -out cert.pem -days 9999 -subj "/C=US/ST=LAIR/L=Lairville/O=Dis/CN=www.lair.fun"
RUN printf '0.0.0.0:11013\ntls cert.pem key.pem\nproxy /api localhost:11015\nproxy / localhost:11014 {\n  websocket\n}\n' > Caddyfile
WORKDIR /root/lair
RUN printf 'rm db/mongod.lock\n./mongodb-linux-x86_64-ubuntu1404-3.0.6/bin/mongod --dbpath=/root/lair/db --bind_ip=localhost --quiet --nounixsocket --replSet rs0 1>&- 2>&- &\nsleep 15s\nexport ROOT_URL=http://localhost\nexport PORT=11014\nexport MONGO_URL=mongodb://localhost:27017/lair\nexport MONGO_OPLOG_URL=mongodb://localhost:27017/local\nsource /root/.bashrc\nsource /root/.nvm/nvm.sh\nnvm use v0.10.40\n./mongodb-linux-x86_64-ubuntu1404-3.0.6/bin/mongo --eval '\''rs.initiate({_id:"rs0", members: [{_id: 1, host: "localhost:27017"}]})'\'' admin 1>&- 2>&-\nsleep 3s\ncd bundle\nnode main.js&\ncd ..\nexport API_LISTENER=localhost:11015\n./api-server_linux_amd64&\n./caddy --conf=Caddyfile&\nwhile true; do sleep 1000; done\n' > start.sh
RUN chmod +x start.sh
CMD ["/bin/bash","-c","/root/lair/start.sh"]
EOF

echo "[*] Downloading and installing Docker"
wget -O dockerinstall.sh https://get.docker.com
chmod +x dockerinstall.sh
./dockerinstall.sh

sleep 5
echo "[*] Setting up Docker Lair instance"
docker build -t lair2 .
docker create -v /root/lair/db --name lairdata lair2 /bin/true

echo "Copy the username and password shown after the following command completes"
echo "Then break it with Ctrl C. The docker daemon should still be running and lair should still be accessible"
echo "Note that the username is admin@localhost"
echo "[*] Starting Lair in 3..2..1.."
sleep 3
docker run --name lair -t -p 11013:11013 --volumes-from lairdata lair2
echo "Complete"
echo "Docker Control reference:"
echo "docker ps -a"
echo "docker stop lair"
echo "docker start lair"
echo "Navigate to https://[DockerIP]:11013"
echo "Testing lair - HTTP 200 = Good to go!" # Note that it doesn't check via localhost
curl -kI https://$(ifconfig | grep "inet addr:" | grep -v 127.0.0.1 | sed 's/inet addr://g' | cut -d ":" -f 1 | awk '{$1=$1}{ print }' | cut -d " " -f 1 | uniq | grep -v 172.*):11013
echo "[*] Script complete"

# Implement static IP / Hostname before installing Docker
# Actually check for root, exit if not
# Convenience - apt-get update && apt-get upgrade
# Convenience - disable ubuntu lockscreen and gnome
# Convenience - Pull lair-drones and push SSH key to authorized hosts via read input
