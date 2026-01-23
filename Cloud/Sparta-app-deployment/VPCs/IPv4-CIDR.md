# Custom VPC Architecture for the 2 Tier Sparta App Deployment

To deploy the Sparta Node.js app in a secure and production style way, a custom VPC is used instead of the default AWS VPC. A VPC provides a private network space where resources can communicate using private IP addresses.

## Creating the VPC

Every network needs an IP address space so devices can talk to each other.
For this deployment, the VPC uses the CIDR block:
```
10.0.0.0/16
```
This provides a large private IP range that can be split into multiple subnets for different purposes.

## Subnet Design

Inside the VPC, two subnets are created:

### Public Subnet
	• Hosts the Application VM
	• Has a route to the Internet Gateway
	• Allows inbound traffic from the internet
	• Protected by security groups
	• Users access the app through this subnet

### Private Subnet
	• Hosts the Database VM (MongoDB)
	• No direct access from the internet
	• Protected by stricter security groups
	• Only allows traffic from the App VM
	• SSH access is not allowed directly from the internet

This separation ensures the database is never publicly exposed.

## Internet Gateway and Routing

### An Internet Gateway (IGW) is attached to the VPC to allow communication with the internet.
	• Users on the internet send requests to the App VM through the Internet Gateway
	• Traffic is routed using route tables associated with the public subnet
	• Internal traffic between the App VM and DB VM stays inside the VPC
	• Security groups control which services can talk to each other

### When the App VM needs to communicate with the Database VM:
	• Traffic leaves the App VM via its security group
	• It is routed internally to the DB VM security group
	• Only approved ports (for example MongoDB on 27017) are allowed

## NAT Gateway Usage

### Because the DB VM is in a private subnet:
	• It cannot access the internet directly
	• A NAT Gateway can be used to allow outbound internet access
	• This is useful for system updates or package installs
	• The DB VM remains unreachable from the public internet

## Access and AMI Usage

### Direct SSH access to the DB VM is disabled for security reasons.
Instead:

	• The DB VM is created from a preconfigured DB AMI
	• Any required configuration is baked into the image
	• If access is required, engineers SSH into the App VM first and then connect internally

⸻

## IPv4 Addressing Explained

IPv4 addresses are 32 bit numbers written as four segments (octets). Each segment can range from 0 to 255.

### Private IPv4 Address Ranges

The following ranges are reserved for private networks:

	• 10.0.0.0 – 10.255.255.255
	• 172.16.0.0 – 172.31.255.255
	• 192.168.0.0 – 192.168.255.255

If an IP address starts with one of these ranges, it is private and not routable on the public internet.

⸻

## CIDR Blocks Explained

CIDR (Classless Inter-Domain Routing) defines how many bits of an IP address are fixed.
```
10.0.0.0/16
```
• An IPv4 address has 32 bits in total

• /16 means the first 16 bits are locked

• The remaining 16 bits can vary

• This allows:

• 256 possible values for the third segment

• 256 possible values for the fourth segment

This gives:
```
256 × 256 = 65,536 IP addresses
```
CIDR blocks make it easy to:

	•	Split networks into subnets
	•	Control IP allocation
	•	Design predictable and scalable architectures