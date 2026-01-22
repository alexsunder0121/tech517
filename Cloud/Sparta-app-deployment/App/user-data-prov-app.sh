#!/bin/bash

# prov-app.sh (User Data)
# Installs nginx + Node 20
# Clones app repo into CURRENT DIRECTORY (root -> /)
# Sets DB_HOST persistently
# Runs app using PM2
# Configures nginx reverse proxy so you don't need :3000

export DEBIAN_FRONTEND=noninteractive

# ---- SET THIS ----
DB_PRIVATE_IP="172.31.32.197"
# ------------------

echo "Updating system..."
apt-get update -y
NEEDRESTART_MODE=a apt-get dist-upgrade -y

echo "Installing nginx, git, curl..."
apt-get install -y nginx git curl

echo "Configuring nginx reverse proxy to port 3000..."
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak

# replace try_files line with proxy_pass
sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://localhost:3000;|' /etc/nginx/sites-available/default

nginx -t
systemctl enable nginx
systemctl restart nginx

echo "Installing Node.js 20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

echo "Installing PM2..."
npm install -g pm2

echo "Setting DB_HOST..."
DB_HOST_VALUE="mongodb://${DB_PRIVATE_IP}:27017/posts"

# Make DB_HOST available now
export DB_HOST="$DB_HOST_VALUE"

# Make DB_HOST persistent for future shells + PM2 reboots
grep -q '^DB_HOST=' /etc/environment && sed -i "s|^DB_HOST=.*|DB_HOST=${DB_HOST_VALUE}|" /etc/environment || echo "DB_HOST=${DB_HOST_VALUE}" >> /etc/environment

echo "Getting app code (clone into current folder)..."
cd /
rm -rf tech517-sparta-app
git clone https://github.com/alexsunder0121/tech517-sparta-app.git

echo "Installing app dependencies..."
cd /tech517-sparta-app/app
npm install

echo "Starting app with PM2 (idempotent)..."
pm2 delete sparta-app || true
pm2 start npm --name sparta-app -- start
pm2 save

echo "App provisioning complete."
echo "Test locally:"
echo "  curl -I http://localhost/posts"
echo "Test in browser:"
echo "  http://<APP_PUBLIC_IP>/posts"