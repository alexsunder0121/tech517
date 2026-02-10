# Intro to Jenkins & CICD

## What is CI?

* Continous Intergration 
* Merging code 
* Triggered by:
  * Developers frequently pushing the code changes to shared repo
* Tests are run automatically on the code before it is integrated into the main code 

### Benefits? 

* Help you to identify and resolve bugs 
  * Reduces costs 
* Helps to main a stable and functional software build
* 

## What is CD? Benefits?

* Can mean:
  * Continous Delivery (manual sign off/approval) OR
  * Continous Deployment (automatically deploys code to production)
  
Continous Delivery:
* Ensure software is always in a deployable state, ready/can be pushed production any time
* Often involves producing deployable artifact 
* Requires a manual release decision
* Benefit:
  * always have a deployable artifact ready to deploy to end users

Continous Deployment
* Extended Continuous Delivery by automating the final step of deploying to production
* No manual intervention required 
* Benefit which is also a disadvantage 
  * removes the human approval, relys entired on automated processes
  * 

## What is Jenkins 

* Automation server
* Open-source
* Primary used for CICD, but can automate much more 

## Why use Jenkins? Benefits of using Jenkins? Disadvantages

* Benefits:
  * Automation 
  * Extensibility: Jenkins has over 1800 plugins 
  * Scalability: Jenkins server can scale easily by adding/using worker nodes/agents to run jobs
  * Community support 
  * Cross-platform: Works across Windows, Linus, MacOS

* Disadvantages:
  * Can be complex for beginners
  * Maintainance overhead
  * Resource-intensive when running multiple jobs
  * User interface: outdated?
  
## Stages of Jenkins 

A typical Jenkins CICD pipeline involves the following stages:
1. Source Code Management (SCM)
2. Build: Compile the code, build into executable artifact
3. Test: Automated tests (unit, integration, etc)
4. Package: Package into deployable artifact 
5. (If using Cont. Deployment) The package is deployed into the target environment e.g. test, production
6. (If using Cont. Deployment) Monitor: Monitoring tools may be deployed/configured to observe performance, log issues, etc after deployment

## WHat alternatives are there for Jenkins 

* GitLab CI
* GitHub Actions
* CircleCI
* Travis CI
* Bamboo
* TeamCity
* GoCD
* Azure DevOps (Azure Pipelines to run the CICD pipelines)


## Why build a pipeline? Business value? 

* Cost savings - automating repetitive processes 
* Faster time to market 
* Reduces risk
* Improved quality through continuous feedback and improvement 


