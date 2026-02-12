# Diagram of Jenkins CI/CD Pipline Architecture 

                         ┌──────────────────────────────┐
                         │        Developer (You)       │
                         │       Working on dev branch  │
                         └──────────────┬───────────────┘
                                        │
                                        │  git push
                                        ▼
                         ┌──────────────────────────────┐
                         │          GitHub Repo         │
                         │      (app code repository)   │
                         └──────────────┬───────────────┘
                                        │
                                        │  Webhook (push event)
                                        ▼
                         ┌──────────────────────────────┐
                         │           Jenkins            │
                         │        Master / Controller   │
                         │   (built in node – controls) │
                         └──────────────┬───────────────┘
                                        │
                                        │ Sends jobs to
                                        ▼
                         ┌──────────────────────────────┐
                         │        Agent / Worker Nodes  │
                         │     (run pipeline jobs)      │
                         └──────────────┬───────────────┘
                                        │
                                        ▼

    ┌────────────────────────────────────────────────────────────┐
    │                      PIPELINE JOBS                         │
    │                                                            │
    │  Job 1: Test Code (dev branch)                             │
    │        ↓ if successful                                      │
    │  Job 2: Merge dev → main                                    │
    │        ↓ if successful                                      │
    │  Job 3: Deploy main branch to EC2                           │
    └────────────────────────────────────────────────────────────┘
                                        │
                                        │ SSH using Jenkins private key
                                        ▼
                         ┌──────────────────────────────┐
                         │         EC2 Instance         │
                         │      (App already running)   │
                         └──────────────────────────────┘




## Git push

When you run git push, you send your latest code changes from your local machine to the remote GitHub repository. This becomes the “source of truth” that Jenkins will pull from. The key point is: Jenkins should build and deploy from the repo, not from your laptop, so everyone is using the same codebase.

## Webhook

A webhook is what connects GitHub to Jenkins automatically. When GitHub receives your push, it sends a message to Jenkins saying “new code has arrived”. That message triggers the pipeline. Without a webhook, Jenkins would only run if you manually clicked build, or if Jenkins kept checking GitHub every few minutes (polling), which is slower and wastes resources.

## Master Node
Master node uses agent/work nodes that will run the jobs 

If any of the jobs crashes it could crash the Jenkins server – security wise this isn’t good 

## Jobs
Each pipeline use has 3 jobs

If result is successful, then it can run the next job

Job 1 – test code (dev branch)

Job 2 – Merge (dev to main branch)

Job 3 – deploy code (deployed onto ec2) must be the same code tested on the Jenkins server. 

## Security 
We need to setup security – Jenkins needs to have access to the private key to do merge 
We need the public key to secure the github repo 
We need to give Jenkins the private key to ssh into the ec2 instance 



# What is a webhook? Why it is needed?

A webhook is an automatic notification sent from one system to another when an event happens.

In this setup:

	1.	You push code to GitHub
	2.	GitHub fires a webhook event (for example: push to dev)
	3.	Jenkins receives it and starts the pipeline immediately

Why needed:

• Faster feedback because builds start instantly

• No polling needed (less wasted CPU)

• Ensures every change is tested consistently

# Why go to the trouble of setting up a CI/CD pipeline? Who has what benefits?

Because it turns “manual steps” into a reliable repeatable process.

Benefits by group:

## Developers

• Faster feedback if code breaks

• Fewer “works on my machine” issues

• Confidence that what gets deployed passed tests

## Team or company

• Consistent releases

• Fewer production incidents

• Easier collaboration because everyone follows the same process

## Users or customers

• More stable app

• Faster delivery of fixes and features

## Ops or platform engineers

• Less manual deployment work

• Better audit trail of what changed and when

• Easier rollback and troubleshooting


# What does each job do?

## Job 1: Test code (dev branch)

• Pulls the latest dev branch code
• Installs dependencies
• Runs tests and basic checks
Goal: stop broken code early

## Job 2: Merge (dev to main)

• Only runs if Job 1 succeeds
• Merges tested changes into main
Goal: protect main so it stays deployable

This step needs secure GitHub access because Jenkins is performing a git operation that writes to the repo.

## Job 3: Deploy code (main to EC2)

• Pulls the main branch (the exact code that passed tests)
• Copies or pulls code onto EC2
• Restarts services if needed (PM2, systemd, etc)
Goal: production or staging matches what was tested


# How can the different parts of the architecture connect securely?

## Developer to GitHub

• Use SSH key or HTTPS with token
• Protect branches (no direct push to main)
• Use PR reviews and required checks

## GitHub to Jenkins (webhook)

• Use a webhook secret token so Jenkins can verify the message is genuinely from GitHub
• Allow inbound webhook traffic only to Jenkins endpoint

## Jenkins to GitHub (merge)

• Use a deploy key or GitHub app token stored inside Jenkins credentials
• Only grant the minimum permissions needed (merge rights only)

## Jenkins to EC2 (deploy)

• Store an SSH private key in Jenkins credentials
• EC2 has the matching public key in authorized_keys
• Limit SSH in security groups to Jenkins controller IP only

## Jenkins master vs agents

• Agents run the risky work (tests, builds)
• Keeps master more stable and reduces security risk
• If a job crashes, you lose an agent, not the Jenkins brain
