# Azure 2-Tier Sparta App Deployment Runbook

## Overview
This runbook documents the full process of deploying the Sparta Node.js application with a MongoDB database on Microsoft Azure using:
- Manual deployment
- Bash scripts
- Azure User Data (cloud-init)

The architecture follows a **2-tier model**:
- **App VM** (public subnet)
- **Database VM** (private subnet)

---

## Architecture
- **VNet**: tech517-alex-2-subnet-vnet
- **Address space**: 10.0.0.0/16
- **Public subnet**: 10.0.2.0/24
- **Private subnet**: 10.0.3.0/24

---

## SSH Key Setup
SSH key generated locally:
```bash
ssh-keygen -t ed25519 -f ~/.ssh/azure-sparta-ed25519
```

Public key uploaded to Azure  
Private key used locally for SSH

---

## Database VM

### Configuration
- Ubuntu 22.04
- Private subnet
- NSG allows:
  - TCP 27017 from App subnet
  - SSH only when debugging

### User Data (prov-db.sh)
```bash
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y curl gnupg

curl -fsSL https://pgp.mongodb.com/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
echo "deb [ arch=amd64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-7.0.list

apt-get update -y
apt-get install -y mongodb-org

sed -i 's/^  bindIp: .*/  bindIp: 0.0.0.0/' /etc/mongod.conf
systemctl enable mongod
systemctl restart mongod
```

---

## App VM

### User Data (prov-app.sh)
```bash
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

DB_PRIVATE_IP="10.0.3.X"

apt-get update -y
apt-get install -y nginx git curl

sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://localhost:3000;|' /etc/nginx/sites-available/default
systemctl restart nginx

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs
npm install -g pm2

echo "DB_HOST=mongodb://${DB_PRIVATE_IP}:27017/posts" >> /etc/environment
export DB_HOST=mongodb://${DB_PRIVATE_IP}:27017/posts

git clone https://github.com/alexsunder0121/tech517-sparta-app.git
cd tech517-sparta-app/app
npm install

pm2 start npm --name sparta-app -- start
pm2 save
```

---

## Validation
```bash
curl http://localhost
curl http://localhost/posts
pm2 status
```

Browser:
```
http://<APP_PUBLIC_IP>/
http://<APP_PUBLIC_IP>/posts
```

---

## Issues & Fixes
- `/posts` 404 → DB_HOST not set
- MongoDB refused → mongod not installed or bindIp wrong
- SSH denied → wrong key uploaded

---

## Outcome
Both pages working  
DB connected privately  
Manual + Bash + User Data deployments complete  
