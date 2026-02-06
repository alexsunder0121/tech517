# Stage 1 Runbook

Provision app node using Ansible and run the Node app in the foreground

## Goal of Stage 1

Use the Ansible controller to provision the app target node so that:

	• Nginx is installed

	• Node.js is installed

	• The Sparta app code is copied onto the target node

	• Dependencies are installed with npm

	• The app is launched in the foreground using npm start

	• The app is reachable directly on port 3000

At this stage I are not trying to make it survive disconnects. Running in the foreground is fine because it proves the app works and I understand the flow.

⸻

## What I started with

	• An Ansible controller VM

	• An app target VM

	• Inventory groups set up so the app node is in the [web] group

	• SSH access working from controller to app node using the pem key

confirmed connectivity first using an Ansible ping:

```ansible web -m ping```

If this returns pong, SSH and inventory setup are correct.


## The main issue I hit

Copy task failed because the path was wrong

The playbook originally tried to copy:

/home/ubuntu/app

But on the controller the app folder actually existed at:

/home/ubuntu/tech517-sparta-app/app

So Ansible couldn’t find the source folder, and the copy task failed.

I fixed that by updating the src path in the copy task.

## What the playbook does in simple terms

It runs one play against the web group (your app node) and does:

1.	Install Nginx, curl, git
2.	Add NodeSource repo for Node 18
3.	Install Node.js
4.	Copy app folder from controller to target node
5.	Run npm install
6.	Start the app using npm start


## How the Stage 1 script works, section by section

Play header

```
- name: install app dependencies and run app
  hosts: web
  become: true
```

What this means:

	• name: a label to describe what the play is doing (shows in output)

	• hosts: web: run this play only on machines in the [web] group in /etc/ansible/hosts

	• become: true: run tasks with sudo because installing software needs root permissions

### Task 1 Install required packages

```
- name: Install required packages
  ansible.builtin.apt:
    name:
      - nginx
      - curl
      - git
    state: present
    update_cache: yes
```

What it does:

	• Uses the apt module (idempotent) meaning if packages are already installed it won’t reinstall them

	• nginx is needed later for reverse proxy (even if Stage 1 is mainly about port 3000)

	• curl is needed to download NodeSource setup script

	• git is useful for later, though  copied the folder in this stage

	• update_cache: yes ensures apt has the latest package index


### Task 2 Add NodeSource repo

```
- name: Add NodeSource Node.js 18 repo
  ansible.builtin.shell: curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
  args:
    creates: /etc/apt/sources.list.d/nodesource.list
```

What it does:

	• Runs the NodeSource script that adds the correct repository for Node 18

	• This is needed because Ubuntu default Node versions are often old

	• creates: makes this task act idempotent:

	• If the file exists, Ansible will skip running this again

Why I used shell here:

	• NodeSource provides repo setup as a script

	• There is no simple apt module option that does this in one line


### Task 3 Install Node.js

```
- name: Install Node.js
  ansible.builtin.apt:
    name: nodejs
    state: present
```

What it does:

	• Installs Node.js from the NodeSource repo added in the previous task
	• Also installs npm along with nodejs

I verified versions later using ad hoc commands like:

```ansible web -m shell -a "node -v && npm -v" -b```

### Task 4 Copy app folder to the target node

```
- name: Copy app folder to target node
  ansible.builtin.copy:
    src: /home/ubuntu/tech517-sparta-app/app/
    dest: /home/ubuntu/app/
    owner: ubuntu
    group: ubuntu
    mode: "0755"
```

What it does:

	• Copies the app code from the controller to the target node

	• This is done over SSH by Ansible

	• The trailing slash on src copies contents inside the folder

	• dest becomes the working app directory on the target node

Why ownership matters:

	• the ubuntu user to be able to run npm install and npm start

	• Without correct ownership you can hit permission issues

### Task 5 Install npm dependencies

```
- name: Install npm dependencies
  ansible.builtin.command: npm install
  args:
    chdir: /home/ubuntu/app
```

What it does:

	• Runs npm install inside the app folder

	• Downloads all Node dependencies from package.json

	• chdir is important so it runs in the correct location

Confirmed dependencies installed:

	• node_modules directory existed

	• package-lock.json appeared

### Task 6 Check if port 3000 is already in use

```
- name: Check if app is already running on port 3000
  ansible.builtin.shell: ss -lntp | grep ':3000' || true
  register: port_check
  changed_when: false
```

What it does:

	• Checks if something is already listening on port 3000

	• Stores output into a variable called port_check

	• changed_when: false stops Ansible pretending this task changed anything

	• || true prevents failure if grep finds nothing


### Task 7 Run the app in the foreground

```
- name: Run app in foreground (npm start)
  ansible.builtin.command: npm start
  args:
    chdir: /home/ubuntu/app
  when: port_check.stdout == ""
```

What it does:

	• Starts the app using the package.json start script

	• Runs only if port 3000 is free

	• Runs in the foreground, so the play can hang because the Node app keeps running


## Overall

Why the app didn’t run in our earlier attempts

	• The app route /posts only exists when DB_HOST is set

	• If DB_HOST is not set, the app still runs but only / works

	• Stage 1 focuses on getting / working first

Foreground vs background

	• Foreground means the terminal process stays running

	• If you disconnect, the app can stop
    
	• This is why Stage 2 uses PM2
