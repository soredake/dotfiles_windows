#!/bin/bash
# Create the user "ubuntu" and create the home directory at /home/ubuntu
sudo useradd -m -s /bin/bash ubuntu

# Add the user to the sudo group
sudo usermod -aG sudo ubuntu

# Optionally, disable password for the user
sudo passwd -d ubuntu
