# Node JS Sparta App Runbook

This document explains how to deploy, run, and manage the Node.js Sparta Test App on an Ubuntu 22.04 virtual machine hosted on AWS EC2.

It is written as a runbook so that another engineer can follow the steps and successfully deploy the application without prior knowledge.

## Architecture for the app

### High Level Architecture

	• Client

A user accesses the application via a web browser using the public IP address of the EC2 instance.

	•	AWS EC2 (Ubuntu 22.04)

Hosts the Node.js runtime and the Sparta test application.

	•	Node.js Application

Runs the backend server and listens on a specific port 

   . (for example, port 3000).

### Architecture Flow

	1.	User sends an HTTP request from their browser
	2.	Request reaches the EC2 instance via the public IP
	3.	Node.js application processes the request
	4.	Response is sent back to the user


### Prerequisites

Before deploying the application, ensure the following are in place:

	•	AWS EC2 instance running Ubuntu 22.04
	•	SSH access to the VM using a .pem key
	•	Security Group allows inbound traffic on:
	•	SSH (port 22)
	•	Application port (for example 3000)
	•	Node.js version 20 installed on the VM
	•	npm installed alongside Node.js


## How to deploy it manually 

1. Copy Application to the VM - From your local machine (Mac):
```
scp -i ~/.ssh/tech517-Alex-aws.pem -r ~/Downloads/nodejs20-sparta-test-app ubuntu@<EC2_PUBLIC_IP>:/home/ubuntu/
```

2. SSH into the VM
```
ssh -i ~/.ssh/tech517-Alex-aws.pem ubuntu@<EC2_PUBLIC_IP>
```

3. Verify Application Files
```
ls
cd nodejs20-sparta-test-app
ls
```

4. Verify Node.js Version
```
node -v
npm -v
```

5. Install Application Dependencies
```
npm install
```
This installs all required dependencies listed in package.json.


### Running the Application

1. Start the Application
```
npm start
```

OR (depending on project setup):
```
node app.js
```
You should see output confirming the server is running and listening on a port.


2. Access the Application

Open a browser and navigate to:
```
http://<EC2_PUBLIC_IP>:<PORT>
```

## How to start and stop the app

1. Stop Manually (Foreground Process)

Press:
```
CTRL + C
```

2. Stop Using Process ID (If Running in Background)

    1. Find the process:
    ```
    ps aux | grep node
    ```

    2. Kill the process
    ```
    kill <PID>
    ```

# Provisioning Script Documentation – prov-app.sh

## Overview

The `prov-app.sh` script is a Bash provisioning script used to automatically set up an Ubuntu 22.04 virtual machine to run a Node.js application.

The script performs the following tasks:
- Updates and upgrades the system
- Installs required software (nginx, git, curl, Node.js v20)
- Clones the application repository from GitHub
- Installs application dependencies
- Runs the Node.js application in the background on port 3000

This allows the VM to be fully configured with a single command.

---

## How the prov-app.sh Script Was Used on the Current VM

The script was first created and tested on an existing Ubuntu 22.04 VM to ensure it worked correctly.

### Steps:
1. The script was created on the new VM using `nano`:
   ```
   nano prov-app.sh
    ```
2.	The script was saved and made executable:
    ```
    chmod +x prov-app.sh
    ```
3.	The script was executed:
    ```
    bash prov-app.sh
    ```
4. The output was monitored to confirm:

 	•	Packages installed successfully

	•	The GitHub repository was cloned

	•	Node.js dependencies were installed

	•	The application started successfully

5.	The application was verified by:

	•	Checking running processes

	•	Checking port 3000

	•	Accessing the app via browser using the VM’s public IP

# Node.js Sparta App – Background Process Management

This document explains how the Sparta Node.js application was run, stopped, and restarted in the background on an Ubuntu virtual machine.
Multiple approaches were tested to understand different background process management techniques and their trade-offs.

## Why the Application Must Run in the Background

When connected to a virtual machine using SSH, any application started in the foreground will stop as soon as the SSH session closes.

Running the app in the background ensures:

	•	The application continues running after logout
	•	Users can access the app via the browser at any time
	•	The app behaves like a real production service

## Method 1: Running the App in the Background Using & and nohup

Command Used

```
nohup npm start > app.log 2>&1 &
```

What This Does

	•	npm start starts the Node.js application

	•	nohup prevents the process from stopping when the SSH session ends

	•	> app.log redirects application output to a log file

	•	2>&1 redirects error output to the same log file

	•	& runs the process in the background

## Method 2: Running the App Using PM2

PM2 is a Node.js process manager designed to keep applications running reliably.

Why PM2 Is Better

	•	Automatically manages background processes
	•	Easy start, stop, restart commands
	•	Prevents duplicate app instances
	•	Provides process status information
	•	Can restart apps if they crash


### Installing PM2

```
sudo npm install -g pm2
```
### Starting the App with PM2

From inside the app directory:
```
pm2 start npm --name sparta-app -- start
```
### Checking App Status
```
pm2 status
```

### viewing logs 
```
pm2 logs sparta-app
```

### stopping the app
```
pm2 stop sparta-app
```
### Test the application
Get the URL and search in web browser 


## How to deploy the database manually 


## How to manually connect the app to the database 

Format for DB_host environment variable to tell app where to find the data base.

Format for it:

```export DB_HOST=mongodb://<IP-ADDRESS>:27017/posts```

This is my IP address (172.31.31.171). 

```export DB_HOST=mongodb://172.31.31.171:27017/posts```
