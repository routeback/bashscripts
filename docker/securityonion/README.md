# Security Onion Docker Container

Description: Autonomously setup a docker container with Security Onion

### Instructions:

```sh
$ nano sosetup.conf # Edit the sosetup.conf
$ ./install.sh # Build the docker image
$ ./start.sh # Connect to the docker container and run the sosetup.sh script
```

### Notes

/etc/init/securityonion.conf waits 60 seconds after boot to ensure network interfaces are fully initialized before starting services.

Possible issues down the road from not utilizing docker properly and sosetup.sh being executed as init: http://phusion.github.io/baseimage-docker/

Review lines 60-70 for reducing 'red' docker ouput during build: https://github.com/moby/moby/blob/master/contrib/mkimage/debootstrap

### Todo

Complete all post-installation instructions and references to them:
https://github.com/Security-Onion-Solutions/security-onion/wiki/PostInstallation

Set the hostname via Dockerfile or sosetup.sh

Make start.sh reveal the IP of the docker container and echo the hostname as https://$hostname

Include instructions on how to access the web interface of Security Onion
Modify install.sh to port forward necessary ports to access the SO interface

Generate SSH key for remote management when not deployed on the local host
Create an SSH config file for quick SSH access w/ alias appened to bashrc and port forwarding of HTTPS server (if necessary)
