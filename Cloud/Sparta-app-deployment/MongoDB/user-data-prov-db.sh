#!/bin/bash

# prov-db.sh (User Data)
# Installs MongoDB 7 on Ubuntu 22.04
# Allows remote connections by setting bindIp to 0.0.0.0
# Starts + enables mongod

export DEBIAN_FRONTEND=noninteractive

echo "Updating system..."
apt-get update -y
NEEDRESTART_MODE=a apt-get dist-upgrade -y

echo "Installing required tools..."
apt-get install -y curl gnupg

echo "Adding MongoDB 7 key..."
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg

echo "Adding MongoDB 7 repo..."
echo "deb [ arch=amd64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" \
> /etc/apt/sources.list.d/mongodb-org-7.0.list

echo "Updating package lists..."
apt-get update -y

echo "Installing MongoDB..."
apt-get install -y mongodb-org

echo "Configuring bindIp to 0.0.0.0..."
sed -i 's/^  bindIp: .*/  bindIp: 0.0.0.0/' /etc/mongod.conf

echo "Starting and enabling mongod..."
systemctl enable mongod
systemctl restart mongod

echo "Checking mongod status..."
systemctl status mongod --no-pager

echo "DB provisioning complete."