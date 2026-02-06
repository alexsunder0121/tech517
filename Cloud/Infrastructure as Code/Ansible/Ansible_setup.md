# Ansible Tutorials and Playbook Workflow

This document combines all Ansible tutorials covering:
- Controller VM setup
- Inventory and SSH configuration
- Ad-hoc commands
- Playbooks for Nginx and system updates
- Managing web and database nodes


## Ansible Controller and Automation Overview

This project demonstrates how Ansible was used to centrally manage and automate configuration across multiple EC2 instances using a controller VM. The process began by setting up the controller machine, updating and upgrading the system, installing Ansible from the official repository, and confirming the installation. An SSH private key was then securely copied onto the controller VM and given the correct permissions so it could authenticate with target nodes. An inventory file was configured to define web and database groups, each containing the relevant EC2 instances along with their connection details. Connectivity was verified using Ansible’s ping module, ensuring the controller could communicate with the target machines without manual SSH access. Ad-hoc commands were then used to run one-off tasks such as checking system information and performing package updates, with built-in Ansible modules preferred over shell commands to maintain idempotency and best practices. Playbooks were created to automate repeatable tasks, including installing and managing Nginx on the web server and running update and upgrade operations across both web and database nodes in a controlled manner. By using Ansible in this way, system configuration became consistent, repeatable, and centrally managed, significantly reducing manual effort and improving reliability when managing multiple servers.

---

## Tutorial 1: Connectivity (Ping)

### 1. SSH into the Controller VM
```bash
ssh ubuntu@<controller-ip>
```

---

### 2. Update and Upgrade the System
```bash
sudo apt update && sudo apt upgrade -y
```

---

### 3. Install Ansible

Add the Ansible repository:
```bash
sudo apt-add-repository ppa:ansible/ansible
```

Update package lists:
```bash
sudo apt update
```

Install Ansible:
```bash
sudo apt install ansible -y
```

Confirm installation:
```bash
ansible --version
```

---

### 4. Navigate to the Ansible Directory
```bash
cd /etc/ansible/
```

---

### 5. Copy SSH Key to Controller VM

Create the SSH key file:
```bash
nano ~/.ssh/tech517-Alex-aws.pem
```

Paste the key contents from your local machine.

Verify the file:
```bash
cat ~/.ssh/tech517-Alex-aws.pem
```

Set correct permissions:
```bash
chmod 400 ~/.ssh/tech517-Alex-aws.pem
```

---

### 6. Configure Inventory

Edit the hosts file:
```bash
sudo nano hosts
```

Example inventory:
```ini
[web]
ec2-instance ansible_host=63.34.9.154 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/tech517-Alex-aws.pem

[db]
ec2-db-instance ansible_host=3.255.195.6 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/tech517-Alex-aws.pem
```

---

### 7. Test Connectivity
```bash
ansible all -m ping
```

---

## Tutorial 2: Ad-Hoc Commands

### Run Commands Using the Command Module
```bash
ansible web -a "uname -a"
ansible web -m ansible.builtin.command -a "uname -a"
ansible web -m command -a "uname -a"
```

> These are ad-hoc commands used for quick, one-off tasks.

---

### Use Idempotent Modules (Best Practice)

Update package cache:
```bash
ansible web -m apt -a "update_cache=true" --become
```

Upgrade packages:
```bash
ansible web -m apt -a "upgrade=dist" --become
```

---

### Check Inventory Structure
```bash
ansible-inventory --list
```

---

### Check if Nginx Is Installed
```bash
ansible web -a "systemctl status nginx" --become
```

---

## Tutorial 3: Creating and Running Playbooks

### Install Nginx Playbook

Create the playbook:
```bash
sudo nano install_nginx.yml
```

Run the playbook:
```bash
ansible-playbook install_nginx.yml
```

---

### Print System Facts Playbook

Create the playbook:
```bash
sudo nano print-facts.yml
```

Run the playbook:
```bash
ansible-playbook print-facts.yml
```

---

## Managing Database Node

Ensure the database VM is running and added to the inventory.

Example DB entry:
```ini
[db]
ec2-db-instance ansible_host=3.255.195.6 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/tech517-Alex-aws.pem
```

After updating the inventory, reconnect from the controller VM.

---

## Notes and Best Practices

- Always prefer Ansible modules over shell or command where possible
- Use playbooks for repeatable and scalable configuration
- Do not destroy nodes once added to inventory
- Test playbooks before running on production environments

---

## Summary

This workflow demonstrates how Ansible can:
- Centrally manage multiple EC2 instances
- Automate configuration tasks
- Reduce manual SSH access
- Provide consistent, repeatable deployments
