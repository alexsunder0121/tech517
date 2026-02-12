# CI/CD Pipeline – Sparta Test App (Jenkins)

- [CI/CD Pipeline – Sparta Test App (Jenkins)](#cicd-pipeline--sparta-test-app-jenkins)
  - [Overview](#overview)
  - [Why I Set Up the CI/CD Pipeline This Way](#why-i-set-up-the-cicd-pipeline-this-way)
    - [Separation of Responsibilities](#separation-of-responsibilities)
  - [Architecture Overview](#architecture-overview)
- [Webhook \& Pipeline Trigger](#webhook--pipeline-trigger)
  - [What is a Webhook?](#what-is-a-webhook)
  - [Job 1 – CI Test (dev branch)](#job-1--ci-test-dev-branch)
    - [Purpose](#purpose)
    - [Configuration](#configuration)
    - [Build Triggers](#build-triggers)
    - [Outcome of Job 1](#outcome-of-job-1)
  - [Job 2 – CI Merge (dev → main)](#job-2--ci-merge-dev--main)
    - [Purpose](#purpose-1)
    - [Trigger Configurations](#trigger-configurations)
    - [Execute Shell commands used](#execute-shell-commands-used)
    - [Security Setup](#security-setup)
    - [Outcome of Job 2](#outcome-of-job-2)
  - [Job 3 – CD Deploy (main → EC2)](#job-3--cd-deploy-main--ec2)
    - [Purpose](#purpose-2)
    - [Trigger Configuration](#trigger-configuration)
    - [Security Setup](#security-setup-1)
    - [Executed Shell Commands](#executed-shell-commands)
    - [Outcome](#outcome)
  - [Summary](#summary)
  - [Benefits of This Pipeline used](#benefits-of-this-pipeline-used)
    - [Technical Benefits](#technical-benefits)
    - [Organisational Benefits](#organisational-benefits)
- [My Learning Obsveration](#my-learning-obsveration)
  - [Verifying Job 2 – Merge Validation (README Change Test)](#verifying-job-2--merge-validation-readme-change-test)
    - [Why I Tested Using README.md](#why-i-tested-using-readmemd)
    - [After Job 2 completed:](#after-job-2-completed)
  - [Verifying Job 3 – Deployment Validation (Homepage Change Test)](#verifying-job-3--deployment-validation-homepage-change-test)
  - [Modifying the View file](#modifying-the-view-file)
    - [What I Did](#what-i-did)
    - [What Happened in the Pipeline](#what-happened-in-the-pipeline)
    - [Verifying the Deployment](#verifying-the-deployment)


## Overview

In this project, I designed and implemented a 3-job CI/CD pipeline using Jenkins to automatically test, merge, and deploy the Sparta Test App from GitHub to an AWS EC2 instance.

The pipeline follows this structure:

1.	Job 1 – CI Test (dev branch)
2.	Job 2 – CI Merge (dev → main)
3.	Job 3 – CD Deploy (main → EC2)

The goal of this setup was to ensure that:

	• All code is tested before being merged.
	• Only validated code reaches the production branch.
	• The live EC2 instance always runs code that has passed automated checks.
	• The entire deployment process is automated and repeatable.


## Why I Set Up the CI/CD Pipeline This Way

### Separation of Responsibilities

	• dev branch → active development and testing
	• main branch → production-ready code
	• EC2 instance → live application

This creates a structured promotion path:

Developer → dev → test → merge → main → deploy → EC2

## Architecture Overview

The full pipeline flow works like this:

1. I push code to the dev branch on GitHub.
2. GitHub sends a webhook to Jenkins.
3. Jenkins automatically starts Job 1 (CI Test).
4. If Job 1 succeeds, Job 2 (Merge) runs.
5. If Job 2 succeeds, Job 3 (Deploy) runs.
6. The EC2 instance is updated and the application restarts.

This creates a CI/CD pipeline triggered directly from GitHub.

# Webhook & Pipeline Trigger

## What is a Webhook?

A webhook is an automatic HTTP callback triggered when an event happens.

For my example:

	• Event: A push to GitHub
	• Action: GitHub sends a POST request to Jenkins
	• Result: Jenkins immediately starts the pipeline


By using a webhook:

	• Builds start instantly.
	• No manual trigger is required.
	• The pipeline responds in real time to changes.

## Job 1 – CI Test (dev branch)

### Purpose

The purpose of Job 1 is to validate new code before it is merged into the production branch.

This job ensures that:

	• Dependencies install correctly.
	• The project builds successfully.
	• Automated tests pass.

If this job fails, the pipeline stops immediately.

### Configuration

Source Code Management

	• Repository: tech517-jenkins-sparta-app
	• Branch: */dev
	• Authentication: SSH key stored in Jenkins credentials

I configured Jenkins with a private SSH key stored securely in the credentials.
The corresponding public key was added to the GitHub repository.

This allows Jenkins to:

	• Clone the repository securely
	• Access private repositories
	• Pull code without using passwords

### Build Triggers

I enabled: GitHub hook trigger for GITScm polling

This allows Jenkins to start the job automatically when code is pushed to GitHub.

To make this work, I configured a webhook inside the GitHub repository:

	• The webhook URL points to my Jenkins server.
	• The endpoint used is /github-webhook/
	• The webhook is triggered on push events.

When I push code to the dev branch:
1.	GitHub sends a POST request to Jenkins.
2.	Jenkins receives the webhook event.
3.	Jenkins checks the repository state.
4.	Job 1 runs automatically.

### Outcome of Job 1 

If tests pass:

	•	The build marked SUCCESS
	•	Job 2 is then able to be triggered automatically

However, if the tests fail:

	•	Build marked FAILURE
	•	Job 2 will not be able to run

This protects the main branch from unstable code.


## Job 2 – CI Merge (dev → main)

### Purpose

The purpose of Job 2 from my understandng is to automatically merge tested code from the dev branch into the main branch.

	• No manual merging required
	• The merge process is consistent and automated.


### Trigger Configurations

I configured Job 2 to:

	• Run after Job 1
	• Only trigger if Job 1 is successful

This means Job 2 will never run if tests fail.

My Configuration:

• Repository: same GitHub repo

• Branch to build: */dev

• SSH authentication: same Jenkins GitHub SSH key


### Execute Shell commands used
1. git checkout main
   1. Jenkins checks out the main branch.
2. git merge origin/dev
   1. It merges changes from origin/dev.
3. git push origin main
   1. It pushes the updated main branch back to GitHub

### Security Setup

1. I added the corresponding public key to GitHub.
2. GitHub grants write access via this key.


### Outcome of Job 2

If Job 1 passes:

	• Job 2 merges dev into main through making changes with the README file
	• The main branch is updated
	• Then i can move onto getting Job 3 to be triggered


## Job 3 – CD Deploy (main → EC2)

### Purpose

The purpose of Job 3 is to deploy the tested and merged code onto the live EC2 instance.


Important rule I made sure to follow was:
* DO NOT git clone on from my main branch and push to production.

This guarantees that production runs exactly what was tested in CI.

### Trigger Configuration

Job 3 is triggered after Job 2 succeeds.

It only runs if the merge was successful.

### Security Setup

Two types of SSH authentication were configured:

1. GitHub Access

	• Jenkins SSH key (private key stored in Jenkins)

	• Public key added to GitHub

Used for:

	• Cloning
	• Merging
	• Pushing

1. EC2 Access
	•	My EC2 .pem private key added to Jenkins credentials
	•	Used by Job 3 via SSH Agent

Used for:

	• SCP / rsync file transfer
	• Remote SSH execution
	• Restarting the app

This keeps credentials secure and prevents them from being exposed in scripts.


### Executed Shell Commands
I use a shell script to deploy the tested code from Jenkins to my EC2 instance and restart the application.

This is the part of the pipeline where Continuous Deployment happens.

* Step 1 – Define the EC2 Instance
  * I store the EC2 public IP in a variable so the script is easier to maintain.
* Step 2 – Copy the Tested Code to EC2
  * I use scp (secure copy) to transfer the app directory from the Jenkins workspace to the EC2 server.
* Step 3 – Install Dependencies and Restart the App
  * Connects to the EC2 server and runs commands remotely.


• Only code that passed CI is deployed.

• Production does not pull directly from GitHub.

• Deployment is fully automated.

• The process is repeatable and safe to re-run.

### Outcome

After Job 3 completes successfully:

• The EC2 instance contains the updated application code

• The application restarts automatically

• The new version is live via the EC2 public IP

• Deployment is fully automated end-to-end

![Description of image](../images/First%20test.png)

## Summary

1.	Developer pushes change to dev
2.	GitHub webhook triggers Jenkins
3.	Job 1 runs tests
4.	If successful → Job 2 merges to main
5.	If successful → Job 3 deploys to EC2
6.	App is updated automatically

## Benefits of This Pipeline used

### Technical Benefits

• Automated testing before deployment

• No manual merges

• No manual deployments

• Reduced human error

• Consistent deployment process

### Organisational Benefits

• Faster release cycles

• Higher confidence in production stability

• Clear separation between development and production

• Traceable build and deployment history

• Improved collaboration between development and operations


# My Learning Obsveration

## Verifying Job 2 – Merge Validation (README Change Test)

### Why I Tested Using README.md

To confirm that Job 2 was actually merging code from dev into main, I made a controlled test change to the README.md file on the dev branch.

What I Did: 
1.	I checked out the dev branch locally.
2.	I added a visible test line to README.md.
3.	I committed and pushed the change to GitHub.
4.	The GitHub webhook triggered Job 1 automatically.
5.	Job 1 ran successfully.
6.	Job 2 was triggered and executed the merge.
7.	I checked the main branch on GitHub.


### After Job 2 completed:

• The main branch contained the updated README change.

• The Git history showed a merge commit created by Jenkins.

• No manual merge was required.

This confirmed that:

• Job 2 correctly merges origin/dev into main.

• Jenkins has correct SSH authentication to push to GitHub.

## Verifying Job 3 – Deployment Validation (Homepage Change Test)

## Modifying the View file
To confirm that Job 3 was deploying the actual tested code to EC2, I modified the application’s homepage view file:

app/views/index.ejs

### What I Did

1.	I checked out the dev branch locally.
2.	I edited index.ejs.
3.	I added a visible line of text to the homepage.
4.	I committed and pushed the change to dev.


### What Happened in the Pipeline

• The webhook triggered Job 1.

• Job 1 ran tests on dev.

• Job 2 merged dev into main.

• Job 3 copied the updated code from Jenkins to EC2.

• Job 3 restarted the application using PM2.


### Verifying the Deployment

After Job 3 completed:

1.	I refreshed the application using the EC2 public IP.
2.	The updated homepage text was visible.
3.	This confirmed that:
	• The updated code was copied to EC2.
	• The app restarted correctly.

![Description of image](../images/second%20test.png)
