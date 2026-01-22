
- [Overview](#overview)
  - [Launch Template Creation](#launch-template-creation)
    - [Steps](#steps)
    - [Why this is important](#why-this-is-important)
  - [Auto Scaling Group Configuration](#auto-scaling-group-configuration)
    - [Steps](#steps-1)
    - [Why this is important](#why-this-is-important-1)
  - [Instance Verification](#instance-verification)
    - [Steps](#steps-2)
    - [Why this is important](#why-this-is-important-2)
  - [Load Balancer Validation](#load-balancer-validation)
    - [Steps](#steps-3)
    - [Why this is important](#why-this-is-important-3)
  - [Final Outcome](#final-outcome)

⸻
# Overview

This document outlines the steps taken to deploy a highly available and auto scaling Node.js application on AWS using a Launch Template, Auto Scaling Group, and Application Load Balancer. The goal of this setup is to ensure reliability, scalability, and minimal downtime by automatically managing instances based on demand.

⸻

## Launch Template Creation

A Launch Template defines how EC2 instances should be created. It ensures consistency across all instances launched by the Auto Scaling Group and removes the need for manual configuration each time a new instance is created.

### Steps
1.	Navigate to EC2 > Launch Templates and select Create launch template.
2.	Select the custom AMI that was previously created for the application.
    - This AMI already contains the operating system, application code, dependencies, and base configuration.
	- Using a custom AMI significantly reduces launch time and removes the need to install software repeatedly.

3.	Choose the instance type as t3.micro.
	- This instance type is cost effective and suitable for low to moderate workloads while still allowing burstable performance.
4.	Select the existing key pair.
	- This allows secure SSH access for troubleshooting, debugging, or emergency access if the application fails to start.
5.	Select the existing security group used previously.
	- This ensures required ports such as SSH and the application port are already allowed.
	- Reusing an existing security group helps maintain consistent security rules.
6.	Add the user data script.
	- User data is executed at instance launch and is used to start services, run provisioning commands, and ensure the application runs automatically.
	- This removes the need for manual intervention after instance creation.
7.	Create the launch template.

### Why this is important

The launch template is the foundation of the entire architecture. It ensures that every instance launched by Auto Scaling behaves in exactly the same way, which is critical for reliability, repeatability, and automation.

⸻

## Auto Scaling Group Configuration

An Auto Scaling Group automatically manages the number of EC2 instances running based on demand, health status, and scaling policies. It is a core component of high availability and fault tolerance.

### Steps
1.	Navigate to EC2 > Auto Scaling Groups and select Create Auto Scaling group.
2.	Provide a name for the Auto Scaling Group and select the previously created launch template.
	- This links the group to the predefined instance configuration.
3.	Keep the VPC as default.
	- Using the default VPC simplifies networking and allows AWS to manage core networking components.
4.	Select availability zones 1a, 1b, and 1c.
	- This distributes instances across multiple data centres to protect against single zone failure.
5.	Under Load balancing, choose to create a new load balancer.
6.	Select Application Load Balancer.
	- This load balancer operates at Layer 7 and is ideal for HTTP based applications.
7.	Choose Internal load balancer scheme.
	- This is suitable when traffic is intended to remain within the VPC or be routed internally.
8.	For Listeners and routing, create a new target group.
	- The target group defines how traffic is routed to EC2 instances.
9.	Enable Elastic Load Balancing health checks.
	- Health checks allow AWS to automatically detect and replace unhealthy instances.
10.	Set the health check grace period to 180 seconds.
	- This prevents instances from being marked unhealthy while the application is still starting.
11.	Configure Group size and scaling:
	- Desired capacity: 2 to ensure redundancy
	- Minimum capacity: 2 to maintain availability
	- Maximum capacity: 3 to allow controlled scaling under load
12.	Enable a scaling policy based on CPU utilisation.
	- This allows the application to automatically respond to increased demand.
13.	Set instance warmup to approximately 180 seconds.
	- This ensures new instances stabilise before being included in scaling decisions.
14.	Add a tag:
	- Key: Name
	- Value: <instance-name> HA + SC
	- Tags help with resource identification, cost tracking, and management.

### Why this is important

The Auto Scaling Group ensures the application remains available, resilient, and cost efficient by automatically managing capacity and replacing failed instances without manual intervention.

⸻

## Instance Verification

Once the Auto Scaling Group is created, it is important to verify that instances are launching correctly and behaving as expected.

### Steps
1.	Navigate to EC2 > Instances.
2.	Confirm that the Auto Scaling Group has launched the expected number of instances.
3.	Select one instance and review its status checks.
	- Both system and instance status checks should be passing.
4.	Copy the public IP address of the instance.
5.	Paste the IP address into a web browser to confirm the application is running.

### Why this is important

This step confirms that:

- The launch template is configured correctly
- User data scripts executed successfully
- The application starts automatically on boot

⸻

## Load Balancer Validation

The Application Load Balancer distributes incoming traffic across all healthy instances in the Auto Scaling Group.

### Steps
1.	Navigate to EC2 > Load Balancers.
2.	Select the load balancer name, not the launch template.
3.	Open the Integrations tab.
4.	Under Load balancing, click the linked target group name.
5.	Review the target group health status.
	- All instances should be marked as healthy.
6.	Return to the load balancer page and copy the DNS name.
7.	Paste the DNS name into a web browser to confirm the application loads correctly.

### Why this is important

The load balancer provides:

- Traffic distribution across instances
- Automatic rerouting away from unhealthy instances
- A single stable endpoint for accessing the application

⸻

## Final Outcome

This architecture successfully delivers:

- High availability across multiple availability zones
- Automatic scaling based on demand
- Fault tolerance through health checks and instance replacement
- Fully automated provisioning using a launch template

