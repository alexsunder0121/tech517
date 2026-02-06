# NEVER DO THIS:
# aws_access_key and aws_secret_key!!

# Create an cloud instance 
# What cloud provider to use
provider "aws" {
    region = "eu-west-1"
}

# Which region to create
# Specify image (AMI)
# Type of instance 
# Public IP address
# Name the instance 

resource "aws_instance" "app_instance" {

    # which AMI ID ami-0c1c30571d2dae5c9 (for ubuntu 22.04 lts)
    ami = "ami-0c1c30571d2dae5c9"

    # what type of instance to launch
    instance_type = "t3.micro"

    # please add a public ip to this instance
    associate_public_ip_address = true

    # name the service
    tags = {
        Name = "tech517-alex-terraform-app"
    }
} 





# EC2 instance - 
/*
resource "aws_instance" "app_instance" {
  ami                         = data.aws_ami.ubuntu_2204.id
  instance_type               = var.instance_type
  associate_public_ip_address = true

  # Attach your existing AWS key pair
  key_name = var.key_name

  # Attach the security group created in security-group.tf
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = var.instance_name
  }
}
*/

 