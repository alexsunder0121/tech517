Overview

This runbook documents the end to end process of deploying the Sparta Node.js application on Microsoft Azure using a two tier architecture. The deployment includes an Application VM in a public subnet and a Database VM in a private subnet. It covers Azure resource setup, SSH access, VM provisioning, application startup, and blockers encountered during deployment.

⸻

# Azure 2 Tier Sparta App Deployment Runbook


Architecture Summary
	•	Cloud Provider: Microsoft Azure
	•	Architecture: Two tier (App VM + DB VM)
	•	OS Image: Ubuntu Server 22.04 LTS
	•	App Runtime: Node.js + PM2 + Nginx
	•	Database: MongoDB
	•	Networking: Custom VNet with public and private subnets

⸻

Azure Networking Setup

Virtual Network
	•	Name: tech517-alex-2-subnet-vnet
	•	Address space: 10.0.0.0/16

Subnets

Public Subnet (App VM)
	•	Name: public-subnet
	•	Address range: 10.0.2.0/24
	•	Internet access enabled

Private Subnet (DB VM)
	•	Name: private-subnet
	•	Address range: 10.0.3.0/24
	•	No public internet access

Network Security Groups

App NSG
	•	SSH (22) allowed from my IP
	•	HTTP (80) allowed from anywhere

DB NSG
	•	MongoDB (27017) allowed ONLY from app subnet
	•	SSH not exposed publicly

⸻

SSH Key Setup
	•	SSH key pair generated locally and reused across both VMs
	•	Public key uploaded to Azure during VM creation
	•	Private key stored locally in ~/.ssh
	•	Correct permissions applied:

chmod 600 ~/.ssh/tech517-alex-2tier-key.pem


⸻

Database VM Setup
	•	VM placed in private-subnet
	•	No public IP assigned
	•	MongoDB installed manually
	•	MongoDB bound to private IP
	•	Private IP confirmed: 10.0.3.5

Connectivity Check

From the App VM:

ping 10.0.3.5

Result: Successful connectivity between App VM and DB VM

⸻

Application VM Setup
	•	VM placed in public-subnet
	•	Public IP assigned
	•	SSH access verified

App Provisioning Steps (Manual)
	1.	Update and upgrade system

sudo apt update -y && sudo apt upgrade -y

	2.	Install required packages

sudo apt install -y nginx git curl

	3.	Install Node.js 20

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

	4.	Install PM2

sudo npm install -g pm2

	5.	Clone Sparta app repository

git clone https://github.com/alexsunder0121/tech517-sparta-app.git
cd tech517-sparta-app/app
npm install

	6.	Set DB_HOST environment variable

export DB_HOST=mongodb://10.0.3.5:27017/posts

	7.	Start app with PM2

pm2 start npm --name sparta-app -- start
pm2 save


⸻

Nginx Reverse Proxy Configuration

Configured Nginx to proxy traffic from port 80 to port 3000

sudo sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://localhost:3000;|' /etc/nginx/sites-available/default
sudo nginx -t
sudo systemctl restart nginx


⸻

Application Verification
	•	Front page accessible via public IP
	•	PM2 status confirmed app running
	•	/posts route tested

curl http://localhost:3000/posts





















⸻

## Blockers and Issues Encountered

SSH Access Issues
	•	Permission denied errors due to incorrect SSH key selection
	•	Fixed by ensuring the same key pair was used for both VMs
	•	Resolved with correct file permissions and Azure key assignment

PM2 Not Found
	•	Occurred because Node and npm were not installed correctly on first run
	•	Fixed by reinstalling Node.js 20 and npm

404 Error on /posts
	•	Root cause identified:
	•	/posts route only loads when DB_HOST is set
	•	MongoDB must be running and reachable
	•	Confirmed issue is DB related, not app logic

Database Accessibility
	•	DB VM correctly unreachable from the internet
	•	Only reachable from App VM via private IP
	•	This matches secure two tier architecture design

⸻

Current Status
	•	Azure VNet and subnets configured correctly
	•	App VM reachable via public IP
	•	App running successfully on PM2
	•	DB VM reachable from App VM
	•	Remaining task: ensure MongoDB is running and seeded correctly to enable /posts

⸻

Next Steps
	•	Verify MongoDB service status on DB VM
	•	Confirm DB_HOST persistence across reboots
	•	Complete posts page verification
	•	Automate setup using Bash scripts and User Data

⸻

Key Takeaways
	•	Azure networking is more explicit than AWS and requires careful NSG configuration
	•	Private subnets prevent direct SSH access to databases
	•	Environment variables must be set before starting PM2
	•	Debugging step by step prevents unnecessary re builds