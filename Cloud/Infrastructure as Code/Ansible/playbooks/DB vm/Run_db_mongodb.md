# Infrastructure Provisioning and Configuration with Terraform and Ansible

Overview

This project demonstrates how Infrastructure as Code and Configuration Management can be combined to deploy and manage a two tier application consisting of:
	•	A Node.js web application
	•	A MongoDB database
	•	Automated provisioning using Terraform
	•	Automated configuration using Ansible

The work was completed in stages, gradually moving from manual setup to a fully automated solution that can be rerun on new virtual machines without additional manual steps.

## Architecture Summary

Controller VM

	•	Runs Ansible

	•	Manages configuration of target nodes

App VM

	•	Runs Node.js application

	•	Exposes HTTP traffic via Nginx reverse proxy

Database VM

	•	Runs MongoDB 7.0

	•	Accepts connections from the app VM


User → Nginx (port 80) → Node.js app (port 3000) → MongoDB (port 27017)


## Stage 1: Provision and Run the App in the Foreground


### What the Stage 1 Playbook Does

The playbook performs the following actions on the web host group:

1.	Installs required system packages:

	•	Nginx
	•	Curl
	•	Git
2.	Installs Node.js:

	•	Adds the NodeSource repository
	•	Installs Node.js 18
3.	Copies the application files:

	•	Transfers the app directory from the controller to the app VM
	•	Ensures correct ownership and permissions
4.	Installs Node.js dependencies:

	•	Runs npm install inside the app directory

5.	Configures Nginx as a reverse proxy:
	•	Listens on port 80
	•	Forwards traffic to the Node.js app on port 3000
6.	Starts the application:
	•	Checks whether port 3000 is already in use
	•	Runs npm start only if the app is not already running

⸻

### Why This Stage Matters

	•	Demonstrates basic Ansible usage
	•	Highlights the difference between foreground and background processes
	•	Shows why foreground processes are unsuitable for production environments
	•	Introduces idempotency checks to avoid duplicate app starts

⸻

## Stage 2: Run the App in the Background Using PM2

Goal

Improve reliability by running the app in the background using PM2.

This stage introduces:

	•	Process management
	•	Environment variables
	•	Safe re-runs of playbooks

⸻

### What Changed from Stage 1
	•	PM2 is installed globally
	•	The app is started as a managed background service
	•	The app survives SSH disconnections and reboots
	•	Playbook can be re-run without creating duplicate processes

⸻

### What the Stage 2 Playbook Does

On the web host group, the playbook:
1.	Installs required packages:

	•	Nginx
	•	Git
	•	Curl
2.	Installs Node.js 18
3.	Installs PM2 globally using npm
4.	Copies application files from controller to app VM
5.	Installs Node.js dependencies using the Ansible npm module
6.	Configures Nginx reverse proxy (same as Stage 1)
7.	Stops any existing app instance safely:

	•	Uses pm2 delete with a fallback to avoid failure
8.	Starts the app using PM2:

	•	Runs npm start
	•	Saves the PM2 process list for persistence

⸻

### Why PM2 Is Important
	•	Keeps the app running in the background
	•	Prevents port conflicts
	•	Makes the app production ready
	•	Allows controlled restarts and logging

⸻

## Stage 3: Database Provisioning and Integration

Goal

Provision MongoDB on the database VM and connect the app to it automatically.

⸻

### Database Playbook Responsibilities

On the db host group, the playbook:

1.	Installs MongoDB 7.0:

	•	Adds MongoDB GPG key
	•	Adds MongoDB repository
	•	Installs the database package
2.	Configures MongoDB networking:

	•	Updates bindIp from 127.0.0.1 to 0.0.0.0
	•	Allows remote connections from the app VM
3.	Restarts and enables MongoDB:

	•	Ensures MongoDB starts on boot
	•	Applies configuration changes

⸻

### Verifying Database Configuration

Ad hoc Ansible commands were used to confirm:

	•	MongoDB is running
	•	MongoDB is listening on port 27017
	•	The bind IP is correctly configured

⸻

### Database Seeding

The application includes a seed script used to populate MongoDB with sample data.

Steps automated in Ansible:

	•	Export the DB_HOST environment variable
	•	Run node seeds/seed.js
	•	Confirm database connection and data insertion

This ensures the /posts page displays real data.

⸻

### Final Automation: One Playbook for App and Database

prov-app-all.yml

To fully automate deployment, both plays were combined into a single playbook:

	•	Play 1 configures the database
	•	Play 2 configures the application

Running one command now:

	•	Installs MongoDB
	•	Configures networking
	•	Seeds the database
	•	Deploys the app
	•	Starts the app in the background
	•	Makes /posts accessible

This playbook can be run on:

	•	Existing target nodes
	•	Brand new target nodes

Without modification.

⸻

## Configuration Drift and Prevention

What Is Configuration Drift

Configuration drift occurs when the actual state of a system differs from its intended configuration over time due to:

	•	Manual changes
	•	Failed deployments
	•	Inconsistent updates

⸻

### How This Project Avoids Drift

	•	Infrastructure is defined using Terraform
	•	Configuration is defined using Ansible playbooks
	•	Playbooks are idempotent
	•	Manual server changes are avoided
	•	Systems can be rebuilt at any time

If a VM is destroyed, the same Terraform and Ansible code can recreate it identically.


## Final Result

The application and database are fully operational.

	•	Home page loads via Nginx
	•	/posts page displays seeded database content
	•	One Ansible playbook configures both tiers
	•	Ready for scaling, CI/CD, and further automation