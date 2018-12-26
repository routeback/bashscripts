#!/bin/sh
# Start customized Kali docker image interactively
# First time setup:
# docker pull kalilinux/kali-linux-docker
# Create a folder for sharing files with the container:
# mkdir -p ~/docker/kalidata
docker run --privileged -it -v ~/docker/kalidata:/root/kalidata kalilinux/kali-linux-docker:latest
