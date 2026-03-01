provider "aws" {
  region = "us-east-1"
}

# Variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-example-terraform-bucket-2024"
}

# S3 Bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Example Bucket"
    Environment = "Dev"
  }
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.example_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Public Access Block
resource "aws_s3_bucket_public_access_block" "example_bucket_public_access_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Output the bucket name
output "bucket_name" {
  value       = aws_s3_bucket.example_bucket.id
  description = "The name of the S3 bucket"
}