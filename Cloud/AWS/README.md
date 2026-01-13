# Creating an EC2 Instance on AWS

## 1. Logged into AWS
- Logged into the **AWS Management Console**
- Navigated to the **EC2** service

---

## 2. Create a Key Pair
- Opened **Key Pairs** under *Network & Security*
- Created a new key pair
- Downloaded the `.pem` file securely
- This key pair is used to securely connect to the EC2 instance via SSH

---

## 3. Launch an EC2 Instance
- Clicked **Launch Instance**
- Configured the instance with the following settings:
  - **Name tag** added to identify the instance
  - **Key pair** selected for SSH access
  - **Network settings** configured (default VPC and security group)
  - Allowed **SSH (port 22)** access

---

## 4. Create an Ubuntu Virtual Machine
- Selected **Ubuntu** as the Amazon Machine Image (AMI)
- Chose an instance type (for example: `t2.micro`)
- Reviewed settings and launched the instance

---

## 5. Instance Status
- EC2 instance successfully launched
- Ubuntu VM is running and ready for SSH access
- To termninate the VM we have to go to the terminal and exit then go back to AWS and go to "Instance Status". From there we can stop the VM from running 