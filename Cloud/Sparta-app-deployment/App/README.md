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

⸻

## Level 1: Manual Deployment (No Automation)

This level covers deploying both the application and the database entirely by hand.
All steps are performed manually after connecting to the virtual machines via SSH.

At this level you:

	• Manually install Node.js and MongoDB
	• Manually copy the application files
	• Manually install dependencies
	• Manually start the app
	• Access the app using port 3000

This level is useful for understanding how the application works at a basic level.


1. Create the EC2 Virtual Machine

A new EC2 instance is created with the following setup:

	•	Operating System: Ubuntu 22.04 LTS
	•	Security Group allows:
	•	SSH (port 22)
	•	Application traffic on port 3000

Once the VM is running, the public IP is noted so the app can be accessed later.

2. Connect to the VM

SSH into the VM using your .pem key.
Once you are connected, you are now working inside the Ubuntu server.

⸻

3. Install Node.js

Install Node.js version 20 (and npm).
This is required because the Sparta app is a Node.js application and cannot run without the Node runtime.

After installing, check that Node and npm are available by confirming the version numbers show correctly.

⸻

4. Get the App Code onto the VM

Move the Sparta test app onto the VM. You can do this in two common ways:

	• Copy it from your local machine using SCP
	• Or download it from GitHub if it’s stored in a repo

Once the files are on the VM, check that the folder exists and contains the app files (especially package.json).

⸻

5. Install the App Dependencies

Inside the app folder, run the dependency install step.
This reads the package.json file and downloads everything the app needs to run.

This step is important because without it, the app will fail with missing module errors.

⸻

6. Start the App

Start the app using the project’s start command.
At this point, the server should begin running and listening on port 3000.

You normally keep the terminal open because at Level 1 the app is running in the foreground.

⸻

7. Test the App in Your Browser

Open a browser and visit the app using the EC2 public IP with port 3000:

	• http://<APP_PUBLIC_IP>:3000
	• http://<APP_PUBLIC_IP>:3000/posts

If the page loads, the deployment has worked.

⸻

8. Stop the App

Since the app is running in the foreground, it can be stopped by pressing Ctrl + C in the terminal.

Also, if you disconnect your SSH session, the app will stop automatically, which is one of the main limitations of Level 1 and the reason automation/background process tools are introduced later.

⸻

## Level 2: Manual Two Tier Deployment (App VM + DB VM)

This level introduces a two tier architecture using separate virtual machines for the application and the database.

At this level:

	• MongoDB runs on a dedicated Database VM
	• The Node.js application runs on a separate Application VM
	• The application connects to the database using the private IP address of the DB VM
	• The DB_HOST environment variable is used to define the database connection string
	• Communication between the app and database stays within the private VPC network
	• Security groups are configured so only the App VM can access MongoDB on port 27017
	• All setup steps are performed manually using SSH

This level improves the overall architecture by separating concerns between the application and database.
It more closely reflects a real world production setup compared to a monolithic deployment.

However, because all steps are still completed manually, this approach is time consuming, error prone, and difficult to reproduce, which highlights the need for automation in later stages.

⸻

## Level 3: Automated Deployment with Bash Scripts

This level introduces automation using Bash provisioning scripts.

At this level you:

	• Create prov-db.sh to automatically install and configure MongoDB
	• Create prov-app.sh to automatically install Node.js, Nginx, PM2, and the app
	• Make scripts idempotent so they can be safely re run
	• Use PM2 to manage the Node.js process
	• Configure Nginx as a reverse proxy so port 3000 is hidden

This level significantly reduces manual work and errors.

⸻

### What Is Implemented at This Level

Two separate provisioning scripts are created:

Database provisioning script (prov-db.sh)
This script is responsible for preparing the MongoDB database virtual machine. It:

	• Updates and upgrades the operating system in non-interactive mode
	• Installs MongoDB from the official repository
	• Configures MongoDB to accept connections from other machines
	• Starts and enables the MongoDB service so it runs automatically on boot

Once this script finishes, the database VM is immediately ready to accept connections from the application.

⸻

### Application provisioning script (prov-app.sh)
This script fully prepares the application virtual machine. 

It:

	• Updates the operating system
	• Installs required packages such as Node.js, Nginx, Git, and curl
	• Downloads the Node.js Sparta application from GitHub
	• Installs application dependencies using npm
	• Uses PM2 to run the app in the background
	• Configures Nginx as a reverse proxy so the app is accessible without specifying port 3000

The application is automatically started and remains running even after the SSH session ends.

⸻

### Idempotency and Why It Matters

Both scripts are designed to be idempotent, meaning they can be run multiple times without breaking the system.

This is achieved by:

	• Removing or replacing existing files before cloning reositories
	• Stopping and deleting any existing PM2 processes before starting the app again
	• Avoiding duplicate installations or conflicting services

Idempotency is critical in real world environments where scripts may need to be rerun during updates, recovery, or scaling.

⸻

### Process Management with PM2

PM2 is introduced at this level to manage the Node.js application. It ensures:

	• The app runs in the background
	• The app can be easily started, stopped, and restarted
	• Duplicate instances on port 3000 are avoided
	• The app can automatically restart if it crashes

This makes the application behave more like a production service rather than a temporary development process.

⸻

### Reverse Proxy Automation with Nginx

Nginx is configured automatically as part of the app provisioning script to act as a reverse proxy.

This means:

	• Nginx listens on port 80
	• Traffic is forwarded internally to the Node.js app on port 3000
	• Users can access the application using:

⸻

## Level 4: Fully Automated Deployment Using User Data

This is the highest level of automation and closest to real world production deployment.

At this level you:

	• Use User Data to run provisioning scripts automatically at VM creation
	• Do not SSH into the VM to set anything up
	• Allow both the DB VM and App VM to fully configure themselves on first boot
	• Clone the app into the root directory because User Data runs as root
	• Automatically set the DB_HOST environment variable
	• Automatically start the app and reverse proxy

When complete:
	• The app is accessible immediately via the App VM public IP
	• The /posts page works without specifying port 3000
	• No manual steps are required after VM creation

⸻

### What Is User Data and Why It Is Used

User Data is a feature provided by AWS EC2 that allows a Bash script to be executed automatically on first boot of a virtual machine.

Important characteristics of User Data:

	• The script runs once only
	• It runs as the root user
	• It executes immediately after the VM is created
	• No SSH access is required for initial setup

Using User Data removes the need to manually log in and run provisioning commands, making deployments faster, safer, and more consistent.

⸻

### What Is Implemented at This Level

At Level 4, both virtual machines use User Data scripts.

⸻

#### Database VM (MongoDB)
The database VM is created with a User Data script that:

	• Updates and upgrades the operating system
	• Installs MongoDB automatically
	• Configures MongoDB to listen on all network interfaces
	• Starts and enables the MongoDB service

Once the DB VM finishes booting, MongoDB is already running and ready to accept connections.

⸻

#### Application VM (Node.js + Nginx)
The application VM uses User Data to:

	• Install Node.js, Nginx, Git, and PM2
	• Clone the Sparta Node.js application repository
	• Install application dependencies
	• Set the DB_HOST environment variable using the private IP of the DB VM
	• Start the Node.js app using PM2
	• Configure Nginx as a reverse proxy to forward traffic from port 80 to port 3000

Because User Data runs as the root user, the application is cloned into the root directory (/), not /home/ubuntu. This satisfies the requirement that the script does not rely on a specific admin user.

⸻

### Key Differences Compared to Previous Levels

Compared to earlier levels, the main changes are:

	• No SSH access is required to configure the VMs
	• All provisioning happens automatically on first boot
	• Scripts must be fully non interactive
	• File paths must work for the root user
	• Environment variables such as DB_HOST must be set inside the script

This approach ensures that the environment is built exactly the same way every time.

⸻

## Final Result

When deployment is complete:

	• Both VMs are fully configured automatically
	• The application starts without manual intervention
	• The app is accessible immediately via the App VM public IP
	• The /posts page works without specifying port 3000
	• The deployment behaves like a production ready system























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

## Provisioning Script Documentation (prov app)

What the App Provisioning Script Does

The prov-app.sh provisioning script is used to fully automate the setup of the Sparta Node.js application on an Ubuntu 22.04 virtual machine. Instead of manually installing software and running commands, the script performs all required steps in the correct order. It updates and upgrades the operating system, installs Nginx, Git, and Curl, and installs Node.js version 20. The script then clones the Sparta test app from GitHub, installs all Node.js dependencies using npm install, and installs PM2 to manage the application process. PM2 is used to start the app in the background and ensure it continues running after logout. Finally, the script configures Nginx as a reverse proxy so users can access the app via port 80 without needing to include :3000 in the browser URL.

### How the Provisioning Script Was Used

The provisioning script was created directly on the App VM using a text editor and then executed to configure the server automatically. First, the script file was created using nano prov-app.sh. Once written, execution permissions were applied using chmod +x prov-app.sh. The script was then run with root privileges using sudo bash prov-app.sh to ensure all system level changes could be applied. After the script completed, the deployment was verified by checking the application status with pm2 status and confirming the reverse proxy worked by sending a request to http://localhost/posts. A successful response confirmed that the application, process management, and reverse proxy were all working as expected.


## Reverse proxy (Nginx)


### Purpose

By default, the Sparta Node.js application runs on **port 3000**.  
This means users would normally have to access the app using:
```
http://<APP_PUBLIC_IP>:3000/posts
```

This is not user friendly and does not reflect a production style setup.

To fix this, **Nginx is configured as a reverse proxy** so that:
- Nginx listens on **port 80** (standard HTTP)
- Requests are forwarded internally to **port 3000**
- Users can access the app without specifying a port

Final user URL:
```
http://<APP_PUBLIC_IP>/posts
```

---

## How the Reverse Proxy Works

- The Node.js app continues to run on **localhost:3000**
- Nginx listens on **port 80**
- Nginx forwards incoming requests to the Node.js app
- The browser only ever communicates with Nginx

This improves:
- User experience
- Security
- Professional deployment standards

---

## Manual Reverse Proxy Setup

The goal of the manual reverse proxy setup is to allow users to access the Sparta Node.js application without including port 3000 in the URL. By default, the application runs on localhost:3000, which is not user friendly. Nginx is used to listen on the standard HTTP port 80 and forward incoming requests to the Node.js app running internally on port 3000. This allows users to access the application using http://<APP_PUBLIC_IP>/posts.

Before making any changes, the application was confirmed to be running correctly on port 3000 using pm2 status and by checking listening ports with ss -tulpn | grep 3000. Once confirmed, the default Nginx site configuration file was backed up to allow recovery if needed. The file /etc/nginx/sites-available/default was then edited, and the existing try_files directive inside the server block was replaced with a proxy_pass http://localhost:3000; rule. This tells Nginx to forward all incoming HTTP traffic to the Node.js application.

After updating the configuration, the syntax was verified using nginx -t to ensure there were no errors, and Nginx was restarted to apply the changes. The reverse proxy was first tested locally using curl -I http://localhost/posts to confirm Nginx was correctly forwarding traffic. Finally, the setup was validated externally by accessing http://<APP_PUBLIC_IP>/posts in a web browser, confirming that the application was reachable without specifying port 3000.


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

What This Stage Does

In this stage, both the MongoDB database VM and the Node.js application VM are deployed automatically using User Data scripts.
This means the VMs fully configure themselves on first boot without any manual SSH steps.
	•	The DB VM installs and configures MongoDB so it is ready as soon as the VM starts
	•	The App VM installs Node.js, nginx, PM2, downloads the app, connects it to the database, and starts the app automatically
	•	The application becomes accessible via the App VM’s public IP without using port 3000, thanks to the nginx reverse proxy

This stage simulates a more realistic production style deployment.

⸻

What Was Done Differently in Stage 3

Compared to earlier stages, the key differences are:
	•	User Data is used

The scripts are pasted into the “User Data” section when creating the VM, instead of being run manually after SSH.
	•	Scripts run as the root user

Because User Data runs as root:
	•	No sudo commands are needed
	•	Files are created in / instead of /home/ubuntu
	•	The app is cloned into the current directory

The app is cloned into the directory of the user running the script (root → /) instead of /home/ubuntu, which meets the Stage 3 requirement.
	•	The database connection is automated

The DB_HOST environment variable is set inside the app script using the private IP of the DB VM, allowing the app to connect automatically on startup.
	•	PM2 is used for process management

PM2 ensures:
	•	The app runs in the background
	•	The app restarts if it crashes
	•	Duplicate instances on port 3000 are avoided
	•	The script is idempotent (safe to run multiple times)
	•	Nginx reverse proxy is configured automatically
nginx listens on port 80 and forwards traffic to the app on port 3000, so users do not need to include :3000 in the URL.


