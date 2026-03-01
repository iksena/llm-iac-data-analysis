provider "aws" {
  region = "us-east-1"
}

# Variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-versioned-bucket-example-2024"
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "production"
}

# S3 Bucket Resource
resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.example_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Output the bucket name and versioning status
output "bucket_name" {
  value = aws_s3_bucket.example_bucket.id
}

output "versioning_status" {
  value = aws_s3_bucket_versioning.versioning_example.versioning_configuration[0].status
}