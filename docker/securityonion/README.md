# Security Onion Docker Container

Description: Autonomously setup a docker container with Security Onion

### Instructions:

```sh
$ nano sosetup.conf # Edit the sosetup.conf
$ ./install.sh # Build the docker image
$ ./start.sh # Connect to the docker container running Security Onion
```

### Todo

Include instructions on how to access the web interface of Security Onion
Modify install.sh to port forward necessary ports to access the SO interface
Generate SSH key for remote management when not deployed on the local host
Create an SSH config file for quick SSH access w/ alias appened to bashrc


