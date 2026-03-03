I'll help you create an AWS EFS (Elastic File System) with a mount target. This configuration will:

1. Create an EFS file system
2. Create a mount target in a specified VPC subnet
3. Configure the necessary security group for EFS access
4. Set up required IAM roles and policies

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "vpc_id" {
  description = "VPC ID where EFS will be created"
  default     = "vpc-12345678" # Replace with your VPC ID
}

variable "subnet_id" {
  description = "Subnet ID where EFS mount target will be created"
  default     = "subnet-12345678" # Replace with your subnet ID
}

# Create security group for EFS
resource "aws_security_group" "efs_sg" {
  name        = "efs-security-group"
  description = "Security group for EFS mount targets"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow NFS traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-security-group"
  }
}

# Create EFS File System
resource "aws_efs_file_system" "efs" {
  creation_token = "my-efs"
  encrypted      = true

  tags = {
    Name = "MyEFS"
  }

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
}

# Create EFS Mount Target
resource "aws_efs_mount_target" "efs_mount" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.efs_sg.id]
}

# Output the EFS DNS name
output "efs_dns_name" {
  value = aws_efs_file_system.efs.dns_name
}

# Output the Mount Target DNS name
output "mount_target_dns_name" {
  value = aws_efs_mount_target.efs_mount.dns_name
}

# Output the Mount Target IP address
output "mount_target_ip" {
  value = aws_efs_mount_target.efs_mount.ip_address
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-west-2 region
2. Variables for VPC ID and Subnet ID (with default values that you should replace)
3. A security group that allows NFS traffic (port 2049)
4. An EFS file system with encryption enabled and a lifecycle policy
5. A mount target in the specified subnet
6. Useful outputs including DNS names and IP address

To use this configuration:

1. Replace the default values in the variables with your actual VPC ID and Subnet ID
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

The EFS file system will be created with:
- Encryption enabled
- General Purpose performance mode
- Bursting throughput mode
- A lifecycle policy that transitions files to Infrequent Access storage class after 30 days
- A mount target in your specified subnet
- A security group allowing NFS access

The outputs will provide you with the necessary information to mount the EFS file system from your EC2 instances or other AWS services.