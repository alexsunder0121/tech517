# Node JS Sparta Test App Runbook (Ubuntu 22.04 on AWS EC2)

This runbook explains how to deploy, run, and manage the Sparta Node JS test app on an Ubuntu 22.04 EC2 virtual machine. It is written so another engineer can follow it step by step.

## Architecture

### High level components

* Client browser  
  A user accesses the app using the public IP of the App VM.

* App VM (AWS EC2, Ubuntu 22.04)  
  Hosts Nginx, Node JS, and the Sparta test app.

* Database VM (AWS EC2, Ubuntu 22.04)  
  Hosts Mongo DB.

### Request flow

1. User sends a request in the browser to the App VM public IP (port 80)
2. Nginx on the App VM receives the request
3. Nginx forwards the request to the Node JS app on localhost port 3000
4. The Node JS app reads and writes data in Mongo DB over the private network (port 27017)
5. Response returns back to the browser

### Simple diagram

User Browser  
↓ HTTP port 80  
Nginx (App VM)  
↓ forwards̵ proxy to localhost port 3000  
Node JS app (App VM port 3000)  
↓ private VPC traffic  
Mongo DB (DB VM port 27017)

## Prerequisites

* EC2 instances running Ubuntu 22.04
* SSH access using a PEM key
* Security groups

### App VM inbound rules

* SSH 22 from your IP (or anywhere for training)
* HTTP 80 from anywhere

### DB VM inbound rules

* SSH 22 from your IP (or anywhere for training)
* Mongo DB 27017 from the App VM security group (preferred)  
  For training only, you might temporarily allow 0.0.0.0/0

## How to deploy the app manually

### 1. Copy the app to the VM (from your local machine)

```bash
scp -i ~/.ssh/tech517-Alex-aws.pem -r ~/Downloads/nodejs20-sparta-test-app ubuntu@<APP_PUBLIC_IP>:/home/ubuntu/
```

### 2. SSH into the VM

```bash
ssh -i ~/.ssh/tech517-Alex-aws.pem ubuntu@<APP_PUBLIC_IP>
```

### 3. Verify files are present

```bash
ls
cd nodejs20-sparta-test-app
ls
```

### 4. Verify Node and npm versions

```bash
node -v
npm -v
```

### 5. Install dependencies

```bash
npm install
```

### 6. Start the app

```bash
npm start
```

If the project is set up for it, you can also run:

```bash
node app.js
```

### 7. Browse to the app

If you are not using a reverse proxy:

```text
http://<APP_PUBLIC_IP>:3000
http://<APP_PUBLIC_IP>:3000/posts
```

If you are using a reverse proxy:

```text
http://<APP_PUBLIC_IP>/
http://<APP_PUBLIC_IP>/posts
```

## How to start and stop the app

### Stop when running in the foreground

Press:

```text
Ctrl + C
```

### Stop when running in the background (basic method)

1. Find the Node process:

```bash
ps aux | grep node
```

2. Stop it:

```bash
sudo kill <PID>
```

If it refuses to stop, use:

```bash
sudo kill -9 <PID>
```

## Background process management

### Why the app must run in the background

If you start the app in the foreground, it will stop when you close your SSH session. Running it in the background keeps it available for users and matches how real services work.

### Method 1: nohup plus ampersand

```bash
nohup npm start > app.log 2>&1 &
```

What this does

* Starts the app
* Keeps it running after logout (nohup)
* Writes logs to app.log
* Runs it in the background (&)

Downside

* Harder to manage and restart cleanly
* Easy to accidentally start multiple copies and hit port 3000 already in use

### Method 2: PM2 (recommended)

PM2 is a process manager for Node JS that makes start, stop, and restart simple and reliable.

Install:

```bash
sudo npm install -g pm2
```

Start from inside the app folder:

```bash
pm2 start npm --name sparta-app -- start
```

Check status:

```bash
pm2 status
```

View logs:

```bash
pm2 logs sparta-app
```

Stop:

```bash
pm2 stop sparta-app
```

Restart:

```bash
pm2 restart sparta-app
```

Save the process list (so the same process list can be restored later):

```bash
pm2 save
```

## How to deploy the database manually (Mongo DB)

1. Create a new Ubuntu 22.04 VM for Mongo DB
2. Ensure inbound rules allow SSH and Mongo DB 27017
3. SSH into the DB VM
4. Install Mongo DB 7 using the official Mongo DB repository
5. Configure Mongo DB to accept connections from other machines by setting bindIp to 0.0.0.0
6. Restart Mongo DB and enable it at boot
7. Note the DB VM private IP address

Useful checks:

```bash
sudo systemctl status mongod --no-pager
sudo ss -tulpn | grep 27017
hostname -I
```

Important note about curl on port 27017  
Mongo DB does not respond like a web server, so curl often shows an empty reply. That does not mean it is broken.

## How to manually connect the app to the database

1. Make sure the DB VM is running
2. Get the DB VM private IP (example: 172.31.31.171)
3. On the App VM, set DB_HOST before starting the app

```bash
export DB_HOST=mongodb://172.31.31.171:27017/posts
```

4. Restart the app so it reads DB_HOST again

With PM2:

```bash
pm2 restart sparta-app
```

5. Test the posts page

```bash
curl -I http://localhost:3000/posts
```

Or in the browser:

```text
http://<APP_PUBLIC_IP>:3000/posts
```

## Provisioning script documentation (prov app)

### What the prov app script does

The app provisioning script automates:

* OS update and upgrade
* Nginx install and restart
* Node JS 20 install
* Git clone of the app repo
* npm install
* PM2 install
* Start the app with PM2
* Configure reverse proxy so port 3000 is not needed in the browser

### How it was used

1. Create the script on the VM:

```bash
nano prov-app.sh
```

2. Make it executable:

```bash
chmod +x prov-app.sh
```

3. Run it:

```bash
sudo bash prov-app.sh
```

4. Verify:

```bash
pm2 status
curl -I http://localhost/posts
```

## Reverse proxy (Nginx)

### Goal

Users should be able to use:

```text
http://<APP_PUBLIC_IP>/posts
```

Instead of needing port 3000.

### Manual steps

1. Confirm the app is running on port 3000:

```bash
pm2 status
sudo ss -tulpn | grep 3000
```

2. Backup the Nginx config:

```bash
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
```

3. Edit the default site config:

```bash
sudo nano /etc/nginx/sites-available/default
```

Inside the server block, replace the existing try_files line with a proxy_pass:

```nginx
location / {
    proxy_pass http://localhost:3000;
}
```

4. Test and restart Nginx:

```bash
sudo nginx -t
sudo systemctl restart nginx
```

5. Test locally:

```bash
curl -I http://localhost/posts
```

6. Test externally in a browser:

```text
http://<APP_PUBLIC_IP>/posts
```

### Automate reverse proxy with sed

You can automate the key line replacement with sed:

```bash
sudo sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://localhost:3000;|' /etc/nginx/sites-available/default
sudo nginx -t
sudo systemctl restart nginx
```

## Stage 2 automation summary (two tier)

At Stage 2 you provision two VMs:

* DB VM runs Mongo DB 7 and listens on port 27017 on the private network
* App VM runs Nginx plus Node JS app and connects to the DB via DB_HOST

## Stage 3 deployment using user data

Key points about user data:

* The script must start with the shebang line
* It runs as root
* It runs once at first boot
* Avoid changing it after pasting into user data, because it is easy to paste the wrong version into the VM and then forget which script actually ran

Stage 3 goal:

* DB provisioning script runs in user data on a fresh DB VM
* App provisioning script runs in user data on a fresh App VM
* App loads in the browser on the App VM public IP and the posts page works
