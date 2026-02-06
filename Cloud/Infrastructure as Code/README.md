# Intro to Infrastructure as Code

## What problem needs solving?

* At the moment, we are still "provisioning" servers

What is "provisioning" servers?
* The process of setting up and configuring servers
 

## What have we automated?

* VMS
  * Creation of the VMs? NO
  * Creation of the infrastructure they live in? NO
  * Setup and configuring of the software on them? Yes, how?
    * Bash scripting
    * User data
    * Images
  * What if we could automate all of it?
  * What if we could codify all of it so that:
    * we do NOT need to define how to get it done (imperative, like our Bash scripts)
    * We define the deseried state/outcome  (and the tool takes care of working out the steps to get us there)
 

## Solving the problem

Infrastructure as Code (IaC) can do all the provisioning of:
* the infrasturcture itself (the servers & the network & extra resources)
* configuring the servers i.e. installing the correct software and configuring the settings in an automated and repetable manner using code

The process typically involves: 
1. creating the server instance 
2. configuring OS and software 
3. deploy application 
4. configuring monitoring and logging 
 

### What is IaC?

* A way to manage and provision computers through machine-readable definitions of infrastrcuture and software configurations
 

### Benefits of IaC?

* Speed and Simplicity 
  * Less manual checking that everything ended up the way it should be, because you are describing the end state required and trusting the tool to work how to get done
* Consistency & Accuracy 
  * Less risk of human error 
* Version control 
* Scalability 
  * Easily re-use code, easily scale or duplicate infrastructure 
  
 

### When/where to use IaC

* Question is: When do you automate something? Ask yourself: Is it worth the invest in time?
* Often used in CI/CD pipelines


### What are the tools available for IaC?

2 types of tools:
* Configuration management tools (about configuring software)
  * Chef 
  * Puppet 
  * Ansible
* Orchistration tools (orchestration of infrastructure)
  * CloudFormation (AWS)
  * ARM/Bicep templates (Azure)
  * Terraform
  * Ansible (Can all do this, but not primarily designed for this)

