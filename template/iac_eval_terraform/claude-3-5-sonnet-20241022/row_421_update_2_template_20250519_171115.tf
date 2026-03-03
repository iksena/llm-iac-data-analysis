provider "aws" {
  region = "us-west-2"
}

# Create EFS File System
resource "aws_efs_file_system" "my_efs" {
  creation_token = "my-efs"
  encrypted      = true
  
  performance_mode = "generalPurpose"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  backup_policy {
    status = "ENABLED"
  }

  tags = {
    Name        = "MyEFSFileSystem"
    Environment = "Production"
    Department  = "Engineering"
    Project     = "SharedStorage"
    ManagedBy   = "Terraform"
  }
}

# Output the EFS File System ID
output "efs_id" {
  value       = aws_efs_file_system.my_efs.id
  description = "The ID of the EFS File System"
}

# Output the EFS File System DNS name
output "efs_dns_name" {
  value       = aws_efs_file_system.my_efs.dns_name
  description = "The DNS name of the EFS File System"
}