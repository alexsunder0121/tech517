#!/bin/bash

# ================================
# Sparta Node.js App Provisioning (User Data)
# Ubuntu 22.04
# ================================
# This script:
# 1. Updates and upgrades the system (no purple screens)
# 2. Installs nginx, git, curl
# 3. Installs Node.js 20
# 4. Sets DB_HOST for MongoDB connection
# 5. Clones the app repo into the CURRENT folder (not /home/ubuntu)
# 6. Installs app dependencies
# 7. Runs the app in the background using PM2
# 8. Sets up nginx reverse proxy (port 80 -> 3000)
# ================================

# Prevent purple restart screens
export DEBIAN_FRONTEND=noninteractive

# CHANGE THIS to your DB VM PRIVATE IP
DB_IP="172.31.44.3"

echo "Updating package lists..."
apt-get update -y

echo "Upgrading system packages..."
NEEDRESTART_MODE=a apt-get dist-upgrade -y

echo "Installing required packages..."
apt-get install -y nginx git curl

echo "Enabling and restarting nginx..."
systemctl enable nginx
systemctl restart nginx

echo "Installing Node.js v20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

echo "Verifying Node.js installation..."
node -v
npm -v

echo "Setting DB_HOST environment variable..."
echo "DB_HOST=mongodb://${DB_IP}:27017/posts" >> /etc/environment
export DB_HOST="mongodb://${DB_IP}:27017/posts"

echo "Getting application code..."

# Clone into CURRENT folder (User Data runs as root, current folder is /)
APP_DIR="$(pwd)/tech517-sparta-app"

# Always start fresh (simple)
rm -rf "$APP_DIR"
git clone https://github.com/alexsunder0121/tech517-sparta-app.git "$APP_DIR"

echo "Moving into app directory..."
cd "$APP_DIR/app"

echo "Installing application dependencies..."
npm install

echo "Installing PM2..."
npm install -g pm2

echo "Stopping any existing app (idempotent step)..."
pm2 stop sparta-app || true
pm2 delete sparta-app || true

echo "Starting app with PM2..."
pm2 start npm --name sparta-app -- start

echo "Saving PM2 process list..."
pm2 save

echo "Setting up reverse proxy (nginx -> port 3000)..."
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
sed -i 's|try_files .*;|proxy_pass http://127.0.0.1:3000;|g' /etc/nginx/sites-available/default

nginx -t
systemctl restart nginx

echo "Provisioning complete."
echo "App should now be running on port 80."
echo "Test in browser: http://<APP_PUBLIC_IP>/posts"