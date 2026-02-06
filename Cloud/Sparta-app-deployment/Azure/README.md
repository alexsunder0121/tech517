# Deployment on Azure

## Differences between AWS and Azure
- Differences
  - resource groups 
    - AWS has resource groups, can be used to group resources, but they don't need to be used 
    - On Azure, everything goes into a resoruce group
  - default for public IP addresses when creating a VM
    - On AWS, dynamic IP addresses are the defualts
    - On Azure, static IP addresses are the defualts
  - Virtual Networking 
    - On AWS, there is a defualt VPC for every region - if you dont change the network settings when creating a VM, your VM will automatically go into the defualt VPC
    - On AAzure, there is no defualt VPC
  - Terminology
    - "Launch VM" on AWS = "Create VM" on Azure
    - AWS VPC = Azure Virtual Network

### Difference we've found as a group

* Virtual Network - need to create one for your VMs to live in 
* Network Security Groups
  * By default, internal network communication is allowed 
  * To make more like AWS (better internal network security), could: 
    * Add the ALLow Mongo DB incoming traffic rule - only from public subnet at a High Priority Level
    * Then disallow everything else (internal traffic-wise)
* Trying to connect your VM via SSH
  * Connect via Native SSh
  * No need for a Bastion server
* Deleting all the parts associated with the VM
  * Make sure you delete:$$
    * VM
    * Disk OS
    * Public IP
    * NIC (Network Interface Card)   
* Images - little more work to use genralised images, easoer to not add to a gallery 
*  