terraform {
  backend "s3" {
    bucket = "amzn-tf-bucket1"
    key    = "wordpress/terraform.tfstate"
    region = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Set AWS region to US East 1 (N. Virginia)
}

# Local variables block for configuration values
locals {
    aws_key = "pk_key1"   # SSH key pair name for EC2 instance access
}

# EC2 instance resource definition
resource "aws_instance" "my_server" {
   ami           = data.aws_ami.amazonlinux.id  # Use the AMI ID from the data source
   instance_type = var.instance_type            # Use the instance type from variables
   key_name      = "${local.aws_key}"          # Specify the SSH key pair name
   vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

   user_data = file("wp_install.sh")
  
   # Add tags to the EC2 instance for identification
   tags = {
     Name = "my ec2"
   }                  
}
# Security group to allow HTTP and SSH access
resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"

  # Allow SSH (port 22)
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP (port 80) - THIS IS THE MISSING PIECE FROM ACTIVITY #3!
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}
