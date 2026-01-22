# Scaling and Auto Scaling Architecture 

## Diagram 1: Types of scaling (for your Node.js app VM)

What “scaling” means

Scaling is how you handle more traffic when your VM is under pressure (usually high CPU, memory, or too many requests).

### Vertical scaling (scale up or down)

You keep one VM, but you change its size.

```
Traffic increases
      |
      v
+-------------------+
|   App VM          |
|   Node.js app     |
|   Nginx proxy     |
+-------------------+
      |
      v
If CPU too high, change instance size
t3.micro  ->  t3.small  ->  t3.medium

Pros: simple
Cons: downtime risk when resizing, there is a limit to how big you can go
```

### Horizontal scaling (scale out or in)

You keep the VM size the same, but you run multiple app VMs.

```
Horizontal scaling (scale out / in)

Traffic increases
      |
      v
Add more App VMs (copies)

App VM 1     App VM 2     App VM 3
+------+     +------+     +------+
| Nginx|     | Nginx|     | Nginx|
| Node |     | Node |     | Node |
+------+     +------+     +------+

Pros: handles big traffic, more reliable
Cons: needs load balancer, app should be stateless
```

## Diagram 2: Auto Scaling Group architecture for your app

What an Auto Scaling Group does

An Auto Scaling Group (ASG) automatically creates or removes identical app VMs based on a rule, usually CPU.

So instead of you manually creating a second VM when traffic rises, AWS does it for you.
```
Auto Scaling Group for Sparta Node.js app

Internet users
      |
      v
+--------------------------+
|  Application Load Balancer|
|  listens on port 80       |
+--------------------------+
      |
      v
+----------------------------------------------+
| Target Group (where traffic gets sent)       |
| Health checks make sure instances are healthy|
+----------------------------------------------+
      |
      v
+--------------------- Auto Scaling Group ---------------------+
|                                                              |
|   Availability Zone A        Availability Zone B              |
|   +------------------+      +------------------+              |
|   | App VM instance  |      | App VM instance  |              |
|   | Nginx :80        |      | Nginx :80        |              |
|   | Node :3000       |      | Node :3000       |              |
|   +------------------+      +------------------+              |
|                                                              |
|   Scaling policy example                                     |
|   If CPU > 60 percent  -> add 1 VM                           |
|   If CPU < 30 percent  -> remove 1 VM                        |
|   Min 2, Desired 2, Max 3                                    |
+--------------------------------------------------------------+

Database (separate, not in ASG)
+------------------+
| MongoDB VM       |
| port 27017       |
+------------------+
```

## Auto Scaling Group Deployment (Launch Template + ASG)

### Goal
Deploy the Sparta app using an Auto Scaling Group so AWS can automatically launch replacement instances if one fails and scale out when needed.

### What I built
- A Launch Template based on my App AMI
- An Auto Scaling Group linked to the Launch Template
- A Security Group allowing:
  - SSH (22) from my IP (optional for troubleshooting)
  - HTTP (80) from anywhere

### Steps I followed
1. Created a Launch Template and selected my App AMI.
2. Added the correct Security Group (HTTP allowed).
3. Added User Data (only needed to start the app from the AMI if it is not already running on boot).
4. Created an Auto Scaling Group using the Launch Template.
5. Set desired capacity (for example 1) so one instance always runs.
6. Verified the instance launched successfully and became “Healthy”.
7. Tested the app in the browser using the instance public IP.

### How I tested scaling
- Increased desired capacity from 1 to 2 and confirmed AWS launched a second instance.
- Reduced desired capacity back to 1 and confirmed AWS terminated one instance.

### Why Auto Scaling helps
- Improves availability: if an instance fails, AWS replaces it automatically.
- Handles load: can scale out to more instances during higher traffic.
- Reduces manual work: no need to manually create new app servers.

