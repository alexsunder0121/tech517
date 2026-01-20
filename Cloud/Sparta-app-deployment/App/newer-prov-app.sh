#!/bin/bash

# ================================
# Sparta Node.js App Provisioning
# Ubuntu 22.04
# ================================
# What this script does:
# 1) Updates the VM
# 2) Installs nginx, git, curl
# 3) Installs Node.js v20
# 4) Downloads the app from GitHub
# 5) Installs app dependencies
# 6) Runs the app in the background using PM2
# ================================

# Prevent purple restart screens
export DEBIAN_FRONTEND=noninteractive

echo "Updating system..."
apt-get update -y
NEEDRESTART_MODE=a apt-get dist-upgrade -y

echo "Installing required packages..."
apt-get install -y nginx git curl

echo "Configuring Nginx reverse proxy..."
sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://localhost:3000;|' \
/etc/nginx/sites-available/default

echo "Checking nginx configuration..."
nginx -t

echo "Enabling and restarting nginx..."
systemctl enable nginx
systemctl restart nginx

echo "Nginx reverse proxy configured."

echo "Installing Node.js v20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

echo "Checking Node version..."
node -v

echo "npm versions..."
npm -v

# Simple: remove old folder, then clone fresh
rm -rf tech517-sparta-app
git clone https://github.com/alexsunder0121/tech517-sparta-app.git

# DATABASE CONNECTION (ADD IT HERE)
# Replace with your DB VM PRIVATE IP
export DB_HOST=mongodb://172.31.40.211:27017/posts

echo "Installing app dependencies..."
cd tech517-sparta-app/app
npm install

echo "Installing PM2..."
npm install -g pm2

echo "Starting app with PM2..."
pm2 stop sparta-app || true
pm2 delete sparta-app || true
pm2 start npm --name sparta-app -- start
pm2 save

echo "Done."
echo "App should now be running on port 3000."
echo "Check: pm2 status"