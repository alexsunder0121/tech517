#!/bin/bash

# purpose: install nginx on a fresh VM
# tested on : Ubuntu 22.04 LTS

#!/bin/bash

echo "Updating the package list to get the latest available versions"
sudo apt update -y

echo "Upgrading installed packages to their latest versions"
sudo apt upgrade -y

echo "Installing the Nginx web server"
sudo apt install nginx -y

echo "Restarting the Nginx service to apply changes"
sudo systemctl restart nginx

echo "Enabling Nginx to start automatically on system boot"
sudo systemctl enable nginx

echo "Downloading the NodeSource setup script for Node.js version 20"
curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh

echo "Running the NodeSource setup script to configure the Node.js repository"
sudo bash nodesource_setup.sh

echo "Installing Node.js version 20"
sudo apt install nodejs -y

echo "Verifying Node.js installation"
node -v
npm -v

echo "Setup complete"


#Part 2

# Step 1: Clone the application repository
# Only clone if the repo does not already exist
if [ ! -d "tech517-sparta-app" ]; then
    echo "Cloning application repository from GitHub..."
    git clone https://github.com/alexsunder0121/tech517-sparta-app.git
else
    echo "Repository already exists, skipping clone."
fi

# Step 2: Change into the application directory
echo "Changing into application directory..."
cd tech517-sparta-app/app || exit 1

# Step 3: Install application dependencies
echo "Installing application dependencies..."
npm install

# Step 4: Start the application in the background
echo "Starting application in the background..."
nohup npm start > app.log 2>&1 &

echo "Application started successfully."
echo "Logs can be found in app.log"



#Part 3

echo "Starting application provisioning"

# Stop script if any command fails
set -e

# 1. Update and upgrade system packages
echo "Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

# 2. Install Nginx
echo "Installing Nginx..."
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl restart nginx

# 3. Install Node.js v20
echo "Installing Node.js v20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs -y

echo "Node version:"
node -v
echo "NPM version:"
npm -v

# 4. Clone the application repository
APP_DIR="tech517-sparta-app"

if [ ! -d "$APP_DIR" ]; then
    echo "Cloning application repository..."
    git clone https://github.com/alexsunder0121/tech517-sparta-app.git
else
    echo "Application repository already exists, skipping clone."
fi

# 5. Change into the app directory
echo "Changing into app directory..."
cd $APP_DIR/app || exit 1

# 6. Install application dependencies
echo "Installing application dependencies..."
npm install

# 7. Run the application in the background
echo "Starting application in the background..."
nohup npm start > app.log 2>&1 &

echo "=============================="
echo "Provisioning complete"
echo "Application is running in the background"
echo "Logs available in app.log"
echo "=============================="


# Part 4
#!/bin/bash

# Exit immediately if a command fails
set -e

# Prevent interactive prompts
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

echo "Disabling needrestart prompts..."
sudo sed -i 's/#$nrconf{restart}.*/$nrconf{restart} = "a";/' /etc/needrestart/needrestart.conf

echo "Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

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

echo "Cloning application repository..."
cd ~

if [ ! -d "tech517-sparta-app" ]; then
  git clone https://github.com/alexsunder0121/tech517-sparta-app.git
else
  echo "Repository already exists. Pulling latest changes..."
  cd tech517-sparta-app
  git pull
fi

echo "Moving into app directory..."
cd ~/tech517-sparta-app/app

echo "Installing application dependencies..."
npm install

echo "Starting app in the background..."
nohup npm start > app.log 2>&1 &

echo "Provisioning complete."
echo "App should be running on port 3000."
echo "View logs with: tail -f ~/tech517-sparta-app/app/app.log"


#Part 4 NEWER VERSION-NOT BEEN TESTED YET

#!/bin/bash

# Disable interactive prompts during installs
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

echo "Cloning application repository..."
cd ~

if [ ! -d "tech517-sparta-app" ]; then
    git clone https://github.com/alexsunder0121/tech517-sparta-app.git
else
    echo "Repository already exists, pulling latest changes..."
    cd tech517-sparta-app
    git pull
fi

echo "Moving into app directory..."
cd ~/tech517-sparta-app/app

echo "Installing application dependencies..."
npm install

echo "Starting application in the background..."
nohup npm start > app.log 2>&1 &

echo "Provisioning complete."
echo "Application should now be running on port 3000."
echo "View logs with: tail -f ~/tech517-sparta-app/app/app.log"

# Part 5

echo "Installing PM2..."
sudo npm install -g pm2

echo "Stopping any existing app (idempotent step)..."
pm2 stop sparta-app || true
pm2 delete sparta-app || true

echo "Starting app with PM2..."
pm2 start npm --name sparta-app -- start

echo "Saving PM2 process list..."
pm2 save

