provider "aws" {
  region = "us-east-1"
}

# Variables
variable "availability_zone" {
  description = "The availability zone where the disk will be created"
  type        = string
  default     = "us-east-1a"
}

variable "disk_name" {
  description = "Name of the Lightsail disk"
  type        = string
  default     = "my-lightsail-disk"
}

variable "disk_size_gb" {
  description = "Size of the disk in GB"
  type        = number
  default     = 8
}

# Create Lightsail Disk
resource "aws_lightsail_disk" "example_disk" {
  name              = var.disk_name
  availability_zone = var.availability_zone
  size_in_gb       = var.disk_size_gb
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Output the disk ARN
output "disk_arn" {
  description = "The ARN of the Lightsail disk"
  value       = aws_lightsail_disk.example_disk.arn
}