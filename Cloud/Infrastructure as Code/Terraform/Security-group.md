# AWS Security Group Configuration (Terraform)

## Overview

This Terraform configuration creates an AWS Security Group that controls inbound and outbound traffic for an EC2 instance.

The security group is designed to:
	•	Allow secure SSH access only from my local machine
	•	Allow public access to the application on ports 3000 and 80
	•	Allow all outbound traffic so the instance can reach the internet and other AWS services

The security group is attached to the default VPC in the selected AWS region.


## Default VPC Lookup

```
data "aws_vpc" "default" {
  default = true
}
```

What this does
	•	Fetches the default VPC in the AWS account
	•	Avoids hardcoding a VPC ID
	•	Makes the configuration portable across accounts and regions

Terraform uses this data source to attach the security group to the correct VPC.

## Security Group Resource

```
resource "aws_security_group" "tech517_alex_tf_allow_22_3000_80" {
  name        = "tech517-alex-tf-allow-port-22-3000-80"
  description = "Allow SSH from my IP, allow 3000 and 80 from all"
  vpc_id      = data.aws_vpc.default.id
```

* What this does
	• Creates a new AWS Security Group
	• The name includes tf to clearly show it was created using Terraform
	• The group is attached to the default VPC

## Inbound Rule: SSH (Port 22)

```
ingress {
  description = "SSH from my IP only"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["77.103.28.163/32"]
}
```

* Purpose

    • Allows SSH access only from my personal public IP

    • /32 ensures only one IP address is allowed

* Why this is good practice

	• Prevents SSH access from the public internet

	• Reduces attack surface

	• Follows the principle of least privilege

## Inbound Rule: Application Port (3000)

```
ingress {
  description = "Allow port 3000 from all"
  from_port   = 3000
  to_port     = 3000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

* Purpose

	•	Allows public access to the Node.js application running on port 3000

	•	Required for testing and development access

* Notes
  
	•	0.0.0.0/0 means any IPv4 address

	•	Acceptable for development environments

	•	Would normally be restricted or fronted by a load balancer in production


## Inbound Rule: HTTP (Port 80)

```
ingress {
  description = "Allow HTTP from all"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

* Purpose
  
	•	Allows public HTTP access

	•	Used when Nginx or another reverse proxy is listening on port 80

	•	Enables access without needing :3000 in the URL

## Outbound Rule: Allow All Traffic

```
egress {
  description = "Allow all outbound"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
```

* Purpose
  
	•	Allows the EC2 instance to:

	•	Download packages

	•	Access external APIs

	•	Communicate with AWS services

* Why this is common
  
	•	AWS security groups are stateful

	•	Outbound traffic is usually unrestricted unless there is a specific reason to limit it

## Tags

```
tags = {
  Name = "tech517-alex-tf-allow-port-22-3000-80"
}
```

* Purpose
  
	•	Makes the security group easy to identify in the AWS console

	•	Helps with cost tracking, auditing, and clarity

	•	Reinforces that Terraform created this resource




https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
