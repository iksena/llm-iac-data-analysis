provider "aws" {
  region = "us-west-2"
}

# Create EFS File System
resource "aws_efs_file_system" "my_efs" {
  creation_token = "my-efs"
  encrypted      = true

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