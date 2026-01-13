#!/bin/bash

# purpose: install nginx on a fresh VM
# tested on : Ubuntu 24.04 LTS

# update command 
sudo apt update 

# upgrade command 
sudo apt upgrade -y

# install nginx 
sudo apt install nginx -y

# restart nginx 
sudo systemctl restart nginx 

# enable nginx - default is already enabled 
sudo systemctl enable nginx 