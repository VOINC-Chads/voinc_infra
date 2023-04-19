#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y docker.io git awscli
sudo systemctl start docker
# curl -O https://dl.google.com/go/go1.16.3.linux-amd64.tar.gz
# sudo tar -C /usr/local -xzf go1.16.3.linux-amd64.tar.gz
# export PATH=$PATH:/usr/local/go/bin
# echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
# source ~/.bashrc
# Get VOINC Backend Here whenever that is ready
# mkdir -p /home/ec2-user/go/src/backend
# cd /home/ec2-user/go/src/backend
# git clone https://github.com/VOINC-Chads/voinc_backend.git
# cd backend
# go build