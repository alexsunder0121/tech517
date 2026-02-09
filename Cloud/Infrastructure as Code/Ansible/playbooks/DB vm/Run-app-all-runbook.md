# Deploying the full stack onto brand new target nodes

This section documents how I proved my automation worked not only on the original targets, but also on fresh new EC2 instances. The goal was to run one playbook that provisions both machines and ends with a working /posts page.

⸻

## Goal

Provision two brand new Ubuntu 22.04 instances using Terraform and then use a single Ansible playbook (prov-app-all.yml) to:

	•	Install and configure MongoDB on the database node
	•	Install and configure Node.js, PM2, and Nginx on the app node
	•	Seed the database so /posts has data
	•	Start the application in the background via PM2
	•	Configure Nginx reverse proxy so the app is accessible on port 80 without :3000


## What “new nodes” means

When I say new nodes, I mean:

	•	I destroyed the previous app and db instances (or they were terminated)
	•	I created completely fresh EC2 instances again (new hostnames, new private IPs)
	•	I re-used the same controller VM and the same controller configuration
	•	The playbook should work without me manually “fixing” anything on the new machines

This is important because it shows the process is repeatable, not a one off manual setup.

⸻

### Steps I followed

1. Deploy new EC2 instances

I ran Terraform from each folder to bring up the instances again. This recreated:

	•	A controller VM (already existed in my case so I did not rebuild it)
	•	A new app target node
	•	A new db target node

After the EC2s were created, I confirmed each node had:

	•	A public IP (so I can SSH in if needed)
	•	Correct security group rules (SSH allowed, plus app or mongo ports depending on node)

⸻

2. Update the Ansible inventory

Because the nodes were new, their IP addresses changed. I updated /etc/ansible/hosts on the controller with the new values.

Example structure:

	•	[web] group contains the app node
	•	[db] group contains the database node

This is essential because the playbook targets machines using these groups.

⸻

3. Confirm SSH from controller to both nodes
Before running any playbook, I verified the controller could connect to both targets using Ansible ping.

If ping fails, nothing else matters because Ansible cannot run tasks. The most common reasons for failure were:

	•	wrong private key
	•	key permissions too open
	•	wrong username
	•	security group blocking port 22
	•	IP changed but inventory not updated

Once both web and db responded with pong, I moved on.

⸻

4. Run the full stack playbook
From the controller:

	•	I ran ansible-playbook prov-app-all.yml

This playbook contains two plays:

	• Section 1 runs against the DB node group
	• Section 2 runs against the Web node group

Ansible runs them in order, which matters because the app should not try to connect or seed until MongoDB is actually ready.

⸻

## What happened during the run (and what I learned)

Database play behavior
The database play does the following:

	•	Adds MongoDB’s official signing key and repository
	•	Installs MongoDB 7.0 packages
	•	Updates /etc/mongod.conf so MongoDB listens on 0.0.0.0
	•	Restarts and enables the mongod service

Why this is required:

	•	Default MongoDB configs often bind only to localhost, meaning the app node cannot connect.
	•	Allowing 0.0.0.0 enables remote connections inside the VPC.

Key validation checks:

	•	systemctl is-active mongod should show active
	•	Mongo should be listening on port 27017

⸻

### App play behavior
The app play does the following:

	•	Installs Nginx, Node.js, and PM2
	•	Copies the Sparta app code from controller to the app node
	•	Installs dependencies using npm
	•	Waits for the database port to be reachable before moving on
	•	Seeds the database (only on first run using a marker file)
	•	Configures Nginx reverse proxy
	•	Starts the app using PM2 and injects DB_HOST

Why the wait step matters:

	•	On new nodes, MongoDB can take time to start.
	•	Without a wait, seeding and app startup might happen too early and fail randomly.

Why seeding matters:

	•	Without seeding, /posts loads but shows no useful post data.
	•	After seeding, /posts returns full data.

⸻

## Testing after the playbook

After the playbook completed, I validated each layer.

1. Check MongoDB from the app node
From the controller I tested connectivity from app to db:

	•	If port 27017 is reachable, app can connect to the database

2. Check the app is running
I checked that port 3000 was listening locally on the app node.

If the app was not listening, the likely causes were:

	•	PM2 process not started correctly
	•	DB_HOST missing in the environment when PM2 started
	•	Node dependencies not installed properly

3. Check the reverse proxy works
I tested that the app loads without :3000, meaning Nginx is routing correctly.

If the default nginx page appears instead of the app, the likely causes are:

	•	nginx default config not overwritten
	•	nginx not restarted
	•	proxy config not applied to correct file
