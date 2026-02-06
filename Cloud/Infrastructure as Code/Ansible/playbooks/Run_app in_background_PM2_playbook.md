# Stage 2 Runbook

Provision app node using Ansible and run the app in the background with PM2

## Goal of Stage 2

The purpose of Stage 2 was to improve on Stage 1 by making the application:
	•	Run in the background instead of the foreground
	•	Survive SSH disconnects
	•	Be restartable and manageable
	•	Be more realistic for production-style deployments

To achieve this, I introduced PM2, a Node.js process manager.


## What PM2 gives us

PM2 solves these problems by:

	• Running the app in the background
	• Allowing named processes (easy to manage)
	• Restarting apps easily
	• Persisting process state

In short, PM2 turns the app into a managed service.


## High-level flow of Stage 2

From the controller, Ansible does the following on the app node:
1.	Installs required system packages
2.	Installs Node.js
3.	Installs PM2 globally
4.	Copies the app code from controller to app node
5.	Installs npm dependencies
6.	Stops any existing app instance (safe re-run)
7.	Starts the app with PM2
8.	Saves PM2 process list


## Stage 2 Playbook Structure

```
- name: install app dependencies and run app with pm2
  hosts: web
  become: true
```

What this does:

	• Targets the web group (app node)

	• Uses sudo where required

	• Describes the purpose clearly for output readability

## Variables section 

```
vars:
  controller_app_path: /home/ubuntu/tech517-sparta-app/app
  target_app_path: /home/ubuntu/app
  app_run_path: /home/ubuntu/app
  app_name: sparta-app
  db_host: "mongodb://127.0.0.1:27017/posts"
```

Why variables are important

Instead of hardcoding paths everywhere, we:

	• Make the playbook easier to read

	• Make changes in one place

	• Reduce mistakes

Each variable represents a real-world concept:

	• Where the app lives on the controller

	• Where it should live on the app node

	• What the app process should be called in PM2

	• Where the database is expected to be


### Install required system packages

What’s happening:

	• Ensures Nginx is installed (used later for reverse proxy)

	• Installs git and curl for tooling

	• state: present makes this idempotent

	• Safe to re-run multiple times

### Add NodeSource Node.js repository

Why this is needed:

	• Ubuntu’s default Node version is often outdated

	• NodeSource provides a maintained, modern Node version

Why creates is important:

	• Prevents re-running the script every time

	• Makes a shell task behave safely and idempotently

## Install Node.js

What this does:

	• Installs Node.js and npm from the NodeSource repo

	• If already installed, nothing changes

### Install PM2 globally

```
- name: Install pm2 globally
  ansible.builtin.npm:
    name: pm2
    global: yes
```

Why PM2 is installed globally:

	• Makes pm2 available system-wide

	• Required for managing the app process

Why we use the npm module:

	• Idempotent

	• Cleaner than running npm install -g pm2 via shell

### Copy app code from controller to app node

What this does:

	• Copies the Sparta app from controller → app node

	• Ensures correct ownership so npm can run

	• Trailing slash copies contents, not the folder itself

### Install app dependencies (npm install)

Why this is important:

	• Installs node_modules using package.json

	• Runs as the ubuntu user (not root)

	• Idempotent – only installs what’s missing

### Start app using PM2 (background)

```
- name: Start app with pm2 (background)
  ansible.builtin.shell: |
    export DB_HOST="{{ db_host }}"
    pm2 start npm --name {{ app_name }} -- start
    pm2 save
  args:
    chdir: "{{ app_run_path }}"
  become_user: ubuntu
```

What happens here:

	• Sets the DB_HOST environment variable

	• Starts the app using npm start

	• PM2 runs it in the background

	• Saves the PM2 process list
