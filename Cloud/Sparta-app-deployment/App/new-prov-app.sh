#!/bin/bash

# ================================
# Sparta Node.js App Provisioning
# ================================
# This script:
# 1. Updates and upgrades the system
# 2. Installs required system packages (nginx, git, curl)
# 3. Installs Node.js version 20
# 4. Clones the Sparta Node.js app from GitHub
# 5. Installs app dependencies
# 6. Runs the app in the background using PM2
# ================================

# Disable interactive prompts during installs
# (prevents purple restart screens)
export DEBIAN_FRONTEND=noninteractive

echo "Updating package lists..."
sudo apt-get update -y

echo "Upgrading system packages..."
sudo NEEDRESTART_MODE=a apt-get dist-upgrade -y

echo "Installing required packages..."
sudo apt-get install -y nginx git curl

echo "Enabling and restarting nginx..."
sudo systemctl enable nginx
sudo systemctl restart nginx

echo "Installing Node.js v20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Verifying Node.js installation..."
node -v
npm -v

echo "Getting application code..."
cd ~

# Clone repo if it doesn't exist, otherwise update it
if [ ! -d "tech517-sparta-app" ]; then
    git clone https://github.com/alexsunder0121/tech517-sparta-app.git
else
    cd tech517-sparta-app
    git pull
fi

echo "Moving into app directory..."
cd ~/tech517-sparta-app/app

echo "Installing application dependencies..."
npm install

echo "Installing PM2..."
sudo npm install -g pm2

echo "Stopping any existing app (idempotent step)..."
pm2 stop sparta-app || true
pm2 delete sparta-app || true

echo "Starting app with PM2..."
pm2 start npm --name sparta-app -- start

echo "Saving PM2 process list..."
pm2 save

echo "Provisioning complete."
echo "App should now be running on port 3000."
echo "Check with: pm2 status"
echo "Logs with: pm2 logs sparta-app"