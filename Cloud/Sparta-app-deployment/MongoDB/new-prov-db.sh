#!/bin/bash

# ================================
# MongoDB 7 Provision Script
# Ubuntu 22.04
# ================================

# Stop if anything fails
set -e

# Prevent purple restart screens
export DEBIAN_FRONTEND=noninteractive

echo "Updating system..."
apt update -y
apt upgrade -y

echo "Installing required packages..."
apt install -y curl gnupg

echo "Adding MongoDB GPG key..."
curl -fsSL https://pgp.mongodb.com/server-7.0.asc \
| gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg

echo "Adding MongoDB repository..."
echo "deb [ arch=amd64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] \
https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" \
> /etc/apt/sources.list.d/mongodb-org-7.0.list

echo "Updating package list..."
apt update -y

echo "Installing MongoDB..."
apt install -y mongodb-org

echo "Allowing remote connections (bindIp 0.0.0.0)..."
sed -i 's/bindIp:.*/bindIp: 0.0.0.0/' /etc/mongod.conf

echo "Starting MongoDB..."
systemctl start mongod
systemctl enable mongod

echo "MongoDB status:"
systemctl status mongod --no-pager

echo "MongoDB setup complete."