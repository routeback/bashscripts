#!/bin/bash

# Setup Script for Security Onion after Docker container is built

sosetup -f /sosetup.conf -y
sudo soup
service nsm restart
