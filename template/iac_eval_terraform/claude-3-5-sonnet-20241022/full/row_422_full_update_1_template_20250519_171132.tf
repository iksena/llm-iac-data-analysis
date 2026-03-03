I'll help you create an AWS EFS (Elastic File System) with lifecycle policy using Terraform. This configuration will:

1. Create an EFS file system with lifecycle management enabled
2. Set up the necessary security group for EFS access
3. Create mount targets in multiple availability zones
4. Configure lifecycle policy to transition files to IA (Infrequent Access) storage class after 30 days
5. Enable encryption at rest

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create VPC (needed for EFS mount targets)
resource "aws_vpc" "efs_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "efs-vpc"
  }
}

# Create subnets in different AZs
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.efs_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "efs-subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.efs_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "efs-subnet-2"
  }
}

# Create security group for EFS
resource "aws_security_group" "efs_sg" {
  name        = "efs-security-group"
  description = "Security group for EFS"
  vpc_id      = aws_vpc.efs_vpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
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

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "MyEFS"
  }
}

# Create mount targets
resource "aws_efs_mount_target" "mount_target_1" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.subnet_1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "mount_target_2" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.subnet_2.id
  security_groups = [aws_security_group.efs_sg.id]
}

# Create backup policy
resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.efs.id

  backup_policy {
    status = "ENABLED"
  }
}

# Output the EFS DNS name
output "efs_dns_name" {
  value = aws_efs_file_system.efs.dns_name
}
</iac_template>

This Terraform configuration creates:

1. A VPC with two subnets in different availability zones
2. A security group that allows NFS traffic (port 2049)
3. An EFS file system with:
   - Encryption at rest enabled
   - Lifecycle policy to move files to IA storage class after 30 days
   - Automatic backups enabled
4. Mount targets in two availability zones for high availability
5. Outputs the EFS DNS name for reference

The lifecycle policy will automatically move files that haven't been accessed for 30 days to the cost-effective IA storage class. The EFS is encrypted at rest for security, and backup is enabled for data protection.

To use this EFS, you would need to:
1. Initialize Terraform
2. Apply the configuration
3. Use the output DNS name to mount the EFS on your EC2 instances or other AWS services

Remember that you'll be charged for the storage used in your EFS and any data transferred to IA storage class.