#!/bin/bash

# update package list
sudo apt update -y

# upgrade packages (auto accept prompts)
sudo NEEDRESTART_MODE=a apt-get dist-upgrade -y

# install nginx, git, curl
sudo apt install -y nginx git curl

# restart nginx (apply changes)
sudo systemctl restart nginx

# enable nginx (start on boot)
sudo systemctl enable nginx

# install NodeJS 20 (no manual script file needed)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

# install nodejs
sudo apt install -y nodejs

# check versions
node -v
npm -v

# clone repo (only if it does not exist)
cd ~
if [ ! -d "tech517-sparta-app" ]; then
  git clone https://github.com/alexsunder0121/tech517-sparta-app.git
fi

# go into app folder (this must match your repo structure)
cd ~/tech517-sparta-app/app

# connect app to database (edit the IP to your MongoDB private IP)
export DB_HOST=mongodb://<MONGODB_PRIVATE_IP>:27017/posts

# install app packages
npm install

# stop app if already running on port 3000 (fresh start)
sudo lsof -ti :3000 | xargs -r kill

# run app in background and save logs
nohup npm start > app.log 2>&1 &

echo "App should now be running on port 3000"
echo "Check logs: tail -f ~/tech517-sparta-app/app/app.log"










#could be used if needed - backup script 


#!/bin/bash

# Simple MongoDB 7 Provision Script (Ubuntu 22.04)

export DEBIAN_FRONTEND=noninteractive

echo "Update system..."
sudo apt update -y
sudo NEEDRESTART_MODE=a apt-get dist-upgrade -y

echo "Install tools..."
sudo apt install -y curl gnupg

echo "Add MongoDB 7 key..."
curl -fsSL https://pgp.mongodb.com/server-7.0.asc \
| sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg

echo "Add MongoDB 7 repo..."
echo "deb [ arch=amd64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" \
| sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list > /dev/null

echo "Install MongoDB..."
sudo apt update -y
sudo apt install -y mongodb-org

echo "Allow remote connections (bindIp 0.0.0.0)..."
sudo sed -i 's/^  bindIp:.*$/  bindIp: 0.0.0.0/' /etc/mongod.conf

echo "Start MongoDB..."
sudo systemctl enable mongod
sudo systemctl restart mongod

echo "MongoDB is ready."


