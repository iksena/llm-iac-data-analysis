I'll help you create an AWS EFS (Elastic File System) with automatic backups enabled using AWS Backup. The configuration will include:

1. An EFS file system with encryption at rest
2. A mount target in a specified VPC subnet
3. AWS Backup vault and backup plan for automatic backups
4. Required IAM roles for AWS Backup
5. Security group for EFS access

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "vpc_id" {
  description = "VPC ID where EFS will be created"
  default     = "vpc-12345678" # Replace with your VPC ID
}

variable "subnet_id" {
  description = "Subnet ID where EFS mount target will be created"
  default     = "subnet-12345678" # Replace with your subnet ID
}

# Security Group for EFS
resource "aws_security_group" "efs" {
  name        = "efs-security-group"
  description = "Security group for EFS mount targets"
  vpc_id      = var.vpc_id

  ingress {
    description = "NFS from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Replace with your VPC CIDR
  }
}

# EFS File System
resource "aws_efs_file_system" "this" {
  creation_token = "my-efs"
  encrypted      = true

  tags = {
    Name = "MyEFS"
  }
}

# EFS Mount Target
resource "aws_efs_mount_target" "this" {
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.efs.id]
}

# AWS Backup vault
resource "aws_backup_vault" "efs_backup" {
  name = "efs-backup-vault"
}

# IAM role for AWS Backup
resource "aws_iam_role" "aws_backup_service_role" {
  name = "aws-backup-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AWS Backup service role policy
resource "aws_iam_role_policy_attachment" "aws_backup_service_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.aws_backup_service_role.name
}

# AWS Backup plan
resource "aws_backup_plan" "efs" {
  name = "efs-backup-plan"

  rule {
    rule_name         = "daily_backup"
    target_vault_name = aws_backup_vault.efs_backup.name
    schedule          = "cron(0 12 * * ? *)" # Daily backup at 12:00 UTC

    lifecycle {
      delete_after = 30 # Keep backups for 30 days
    }
  }
}

# AWS Backup selection
resource "aws_backup_selection" "efs" {
  name         = "efs-backup-selection"
  plan_id      = aws_backup_plan.efs.id
  iam_role_arn = aws_iam_role.aws_backup_service_role.arn

  resources = [
    aws_efs_file_system.this.arn
  ]
}
</iac_template>

This Terraform configuration creates:
1. An encrypted EFS file system
2. A mount target in the specified subnet with a security group allowing NFS traffic (port 2049)
3. An AWS Backup vault to store the backups
4. An AWS Backup plan that performs daily backups at 12:00 UTC and retains them for 30 days
5. The necessary IAM role and permissions for AWS Backup to perform its operations
6. A backup selection that associates the EFS file system with the backup plan

To use this configuration:
1. Replace the default VPC ID and subnet ID with your actual values
2. Adjust the security group CIDR blocks according to your network configuration
3. Modify the backup schedule and retention period if needed
4. Ensure you have the necessary permissions to create these resources in your AWS account

The backup plan will automatically create daily backups of your EFS file system, and you can restore from these backups when needed through the AWS Console or API.