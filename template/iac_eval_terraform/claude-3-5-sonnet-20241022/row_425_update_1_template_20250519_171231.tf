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