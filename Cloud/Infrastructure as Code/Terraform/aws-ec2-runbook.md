# Terraform – Multi-Stage Infrastructure Tasks Runbook

## Overview

In this set of tasks, I used Terraform to provision AWS infrastructure across multiple stages.
The goal was to:
	1.	Deploy application and database EC2 instances using Terraform
	2.	Improve security by separating resources and tightening access
	3.	Prepare clean EC2 instances ready for Ansible configuration management

Each stage built on the previous one and helped reinforce best practices around Infrastructure as Code (IaC), security groups, and environment separation.

# Terraform Part 1 Runbook (AWS): Deploy App VM Only (Front Page)

## Goal
Use Terraform to deploy a single EC2 instance that runs the Sparta app front page only.

This part does not deploy a database. You are proving that Terraform can:
- Create the app security group
- Create an EC2 instance using your app AMI (or Ubuntu if required)
- Attach the correct key pair so you can SSH in
- Optionally run user data to start the app and configure Nginx
- Output the public IP so you can test in the browser

## Expected outcome
- Terraform finishes with no errors
- You can SSH into the instance using your key
- In a browser, your app front page loads at:
  - http://<INSTANCE_PUBLIC_IP>/
- If Nginx is used as a reverse proxy, you do not need :3000

---

## Prerequisites
Before starting:
- AWS credentials are available on your laptop (best practice: AWS CLI profile via aws configure)
- Terraform is installed and works (terraform -v)
- You know your AWS key pair name (example: tech517-Alex-aws)
- You have your app AMI ID ready (example: ami-xxxxxxxxxxxxxxxxx)
- You know your public IP for SSH, in CIDR format (example: 77.103.28.163/32)

Quick checks:
```bash
aws sts get-caller-identity
terraform -v
```

---

## Folder structure for Part 1
Inside your repo, keep Part 1 isolated in its own folder:

```
create-ec2-app-only/
  main.tf
  variables.tf
  security-group.tf
  outputs.tf
  user-data.sh        (optional, only if you need to start services)
  terraform.tfvars    (recommended, to store AMI ID and your IP)
```

---

## Step 1: Provider and region
### What this is for
Terraform needs to know which cloud provider to talk to and which region to deploy into.

### What it looks like
In your provider block you set the region, usually from a variable.

Key idea:
• Provider config tells Terraform where to create things.

---

## Step 2: Choosing the AMI
### What this is for
An AMI is the machine image your EC2 instance will boot from. In Part 1 you used a custom app AMI so the VM already contains the Sparta app and the tools needed to run it.

Why this matters:
• Using a custom AMI makes this deployment faster because you do not have to install everything from scratch each time.

Two common approaches:
1. Hard code the AMI ID as a variable and set it in terraform.tfvars  
2. Use a data source to look up an AMI automatically

For this task, using your custom AMI ID is totally fine and is the most direct option.

---

## Step 3: Creating the app security group
### What this is for
A security group controls what traffic can enter and leave the instance.

For the app VM in Part 1, the rules usually are:
1. SSH port 22 from your home IP only  
2. HTTP port 80 from anywhere  
3. App port 3000 from anywhere (sometimes needed for testing)

Why SSH is restricted:
• SSH should not be open to the world because it increases risk. Limiting it to your IP makes it safer.

Why port 80 is open:
• The browser needs to reach the web server.

Why port 3000 might be open:
• If you want to test the Node app directly on 3000  
• If you are using Nginx reverse proxy to 3000, the public port should be 80 and 3000 can be optional

Important note:
• When you are using Nginx reverse proxy, your browser normally uses port 80 and Nginx forwards to port 3000 internally.

---

## Step 4: Creating the EC2 instance
### What this is for
This creates the actual VM.

Key settings you used:
1. ami  
   • This decides what image the VM boots from  
2. instance type  
   • This decides the size, for example t3.micro  
3. key name  
   • This attaches your existing AWS key pair so SSH works  
4. vpc security group ids  
   • This attaches the security group you created

Common mistake to avoid:
• Confusing AWS key pairs with AWS access keys.  
  The EC2 key pair is the SSH key pair name in AWS, like tech517 Alex aws.

---

## Step 5: User data (optional in Part 1)
### What user data is
User data is a script that runs once on first boot. It is useful to start services automatically.

In Part 1, you only need the front page, so user data is optional if your app AMI already starts the app automatically.

If your AMI does not auto start services, user data can do things like:
1. Navigate to the app folder
2. Start or restart the app using PM2
3. Restart Nginx

Why this helps:
• It makes the VM come up ready without you needing to SSH in and run manual commands.

---

## Step 6: Outputs (how you quickly test)
### What outputs are for
Outputs print useful values after apply. For example:
• The public IP of the instance  
• The security group id

Why this helps:
• You do not have to hunt around the AWS console for the IP.

---

## Step 7: Commands you ran and what they mean
### terraform init
What it does:
• Downloads the AWS provider plugin  
• Sets up the local Terraform working folder

You run it:
• Once per folder when starting  
• Again if you change providers or modules

### terraform fmt
What it does:
• Formats the Terraform files neatly

### terraform validate
What it does:
• Checks your configuration is syntactically valid  
• Catches missing references and obvious mistakes

### terraform plan
What it does:
• Shows what Terraform will create or change  
• Does not create anything yet

Why it matters:
• You can spot mistakes before apply

### terraform apply
What it does:
• Creates the AWS resources

### terraform destroy
What it does:
• Removes everything Terraform created in that folder  
• Use this when you finish testing to avoid costs




