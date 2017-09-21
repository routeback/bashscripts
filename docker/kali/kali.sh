#!/bin/sh

# Start customized Kali docker image interactively

docker run --privileged -it -v ~/docker/kalidata:/root/kalidata kali4:security

