# Understanding AWS VPCs and Subnets

An Amazon Virtual Private Cloud (VPC) is a logically isolated network within AWS where you control how resources communicate with each other and with the internet. It allows you to design your own network architecture, including IP ranges, subnets, routing, and security controls.

## Default VPC and Default Subnets

When an AWS account is created, AWS automatically provides a default VPC. This default VPC includes:

	• Three public subnets
	• One subnet in each Availability Zone (for example: eu-west-1a, eu-west-1b, eu-west-1c)
	• Automatic internet access via an Internet Gateway

These default subnets are simple to use but are shared and less secure, making them suitable for learning or testing rather than production systems.

If an additional Availability Zone is introduced in the region, AWS automatically associates it with the default VPC, usually extending the existing public subnet structure.

## Why Use a Custom VPC

A custom VPC gives full control over network design and security. Instead of placing everything into public subnets, you can separate resources based on their role.

### Key benefits of a custom VPC include:

	• Stronger security boundaries
	• Clear separation between public and private resources
	• Controlled traffic flow using route tables and security groups
	• A more realistic production style architecture

### Public and Private Subnets

In a typical two tier application architecture:

• Public subnet
	• Hosts internet facing resources
	• Example: Application VM, load balancer
	• Has a route to the Internet Gateway

• Private subnet
	• Hosts internal resources
	• Example: Database VM
	• No direct access from the internet

For the Sparta Node.js app:

	• The Node.js application VM is placed in a public subnet so users can access it via HTTP
	• The MongoDB database VM is placed in a private subnet to prevent direct public access

This design ensures the database can only be reached by the application, not by users on the internet.

## Security and Traffic Flow

Using a custom VPC allows tighter security controls:

	• Security groups can restrict database access to only the app VM
	• Private subnets prevent accidental public exposure of sensitive services
	• Traffic between app and database stays within the AWS private network

This reduces the attack surface and aligns with best practice cloud architecture.









IPv4 Addressing and CIDR Blocks

When creating a custom VPC, you define an IPv4 CIDR block (for example 10.0.0.0/16).
This address range is then divided into smaller CIDR blocks for each subnet, such as:
	•	10.0.1.0/24 for a public subnet
	•	10.0.2.0/24 for a private subnet

CIDR blocks control how many IP addresses are available and allow structured, predictable network design.

Summary

Using a custom VPC with public and private subnets:
	•	Improves security
	•	Separates application and database responsibilities
	•	Gives full control over network traffic
	•	Mirrors real world production deployments

This approach forms the foundation for scalable, secure cloud architectures.