# Intro to Ansible

## What is Ansible 

* A configuration management tool
* Red Hat leads development 
* Open-source
* Written in python
* Started with a few core modules that managed Linux Servers
* Works with almost any system 
  * Linux & Windows servers
  * Routes and Switches 
  * Cloud Services


## How does it work?

* Recipe (code)
* Ansible (robot) follows the recipe 
* Recipe (the actions/tasks/instructions) are written in YAML called "playbooks"
* Ansible control node tells the target nodes what to do
* Agentless
  * No need to install Ansible on target nodes
  * Instead, using SSH to access target nodes + it also needs Python interpreter on Linux target nodes


## Host file first entry 

ec2-instance ansible_host=18.201.9.251 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/tech517-Alex-aws.pem



## What is configuration drift? and How can we avoid it?

Configuration drift is when servers that are meant to be identical slowly become different over time, usually because of manual changes, inconsistent updates, or fixes being applied to one machine but not another. 

This can cause unpredictable behaviour, bugs that are hard to trace, and “it works on my machine” problems. We avoid configuration drift by using Infrastructure as Code tools like Terraform and Ansible, which define the desired state of our infrastructure and servers in code. Ansible playbooks are idempotent, meaning they can be run multiple times and will only make changes if something is missing or incorrect. 

By avoiding manual SSH changes, using process managers like PM2, and regularly reapplying playbooks, we ensure systems stay consistent, reproducible, and easy to recover if something goes wrong.

